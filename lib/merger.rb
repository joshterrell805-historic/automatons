require 'array'

require 'psych'
require 'java'
java_import 'MergeAccelerator'
class Merger
   attr_accessor :config, :threshold
   def initialize db
      @db = db
      @msplitter = Splitter::MergeSplitter.new db
      @config = [{'fields' => 'all', 'weight' => 1}]
      @threshold = 0.9
      @accelerator = MergeAccelerator.new
   end

   def merge_records first, second
      # TODO Really merge record
      merge_reason = "merge duplicate records"

      if first[:mId].nil? and second[:mId].nil?
         # BEGIN Do this in a later step in future
         merged = first
         merge_reason = "merge duplicate records"

         @msplitter.insert_merged_record merged
         first[:mId] = second[:mId] = merged[:mId]
         # END do in later step

         @msplitter.insert_contrib_record first, merge_reason
         @msplitter.insert_contrib_record second, merge_reason
      else
         if first[:mId].nil?
            first[:mId] = second[:mId]
            @msplitter.insert_contrib_record first, merge_reason
         end

         if second[:mId].nil?
            second[:mId] = first[:mId]
            @msplitter.insert_contrib_record second, merge_reason
         end
      end
   end

   def match_record_threaded record, records
      high_score = 0
      pair = nil


      threads = []
      record = java.util.HashMap.new(record)
      records.split(1500) do |hunk|
      #hunk = records
         threads << Thread.new do
            hunk = hunk.map do |r|
               java.util.HashMap.new(r)
            end
            match_record record, hunk
         end
      end

      threads.map do |thr|
         th_high, th_pair =  thr.value
         if th_high > high_score and th_high > @threshold
            high_score = th_high
            pair = th_pair
         end
      end
      pair
   end

   def match_record record, hunk
      high_score = 0
      pair = nil
      hunk.each do |other|
         score = @accelerator.score_records @java_rules, record, other
         if score > @threshold
            p "Over threshold"
            p score
            p record
            p other
         end
         if score > @threshold and high_score < score
            high_score = score
            pair = other
         end
      end
      [high_score, pair]
   end

   def match_record_list list
      start = Time.now
      count = 0

      @java_rules = @config.map do |rule|
         java.util.HashMap.new(rule)
      end

      @java_rules.each do |rule|
         rule["fields"] = rule["fields"].to_java
      end

      javalist = list.map do |record|
         java.util.HashMap.new(record)
      end

      list.each_with_index do |record, i|
         pair = match_record_threaded record, list[i+1..-1]
         # TODO If a record matches a merged record, it should be combined into
         # a merge clump

         if pair
            pair = pair.to_hash
            puts "paired a record"
            merge_records record, pair
         else
            @msplitter.insert_new_merge record
         end
         count += 1
         puts "#{count} records merged"
         if count >= 1000
            puts "Total time: #{Time.now - start}s"
            exit
         end
      end
      count
   end
end

class Array
   def split n
      max = length

      i = 0
      while i+n < max
         yield self[i..i+n]
         i += n
      end

      if i < max
         yield self[i..-1]
      end
   end
end
