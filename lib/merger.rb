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
   end

   def score_records record, other
      points_possible = 0
      rule_scores = @config.map do |rule|
         weight = rule['weight']
         fields = rule['fields']
         if fields == 'all'
            fields = record.keys
         end

         #rule_total = rule_total fields, weight, record, other
         rule_total = MergeAccelerator.rule_total fields.to_java, weight, record, other

         if rule_total
            # Add the rule's weight to the points possible
            points_possible += weight
            # Return the score for the rule
            rule_total/fields.length.to_f
         else
            # A field was nil
            # Don't add the rule's weight
            # Return 0 to not change the sum
            0
         end
      end

      total_points = rule_scores.reduce(0, :+)
      total_points/points_possible
   end

   def rule_total fields, weight, record, other
      scores = fields.map do |field|
         val1 = record[field]
         val2 = other[field]

         if val1.nil? or val2.nil?
            return nil
         end

         MergeAccelerator.edit_dist(weight, val1, val2)
      end
      scores.reduce(0, :+)
   end

   ## Returns a value between 0 and 1, with 0 being completely
   #dissimilar, and 1 being identical
   def edit_dist weight, val1, val2
      # TODO: Real edit distance
      val1 == val2 ? weight : 0
   end

   def score_pair key, val1, val2
      default = 1
      if @scores.key? key
         if val1==val2
            @scores[key]
         end
      else
         if val1 == val2
            default
         end
      end
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
         score = MergeAccelerator.score_records @java_rules, record, other
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
