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

   def merge_records first, second, rules
      # TODO Really merge record
      if first[:mId].nil? and second[:mId].nil?
         # BEGIN Do this in a later step in future
         merged = first

         @msplitter.insert_merged_record merged
         first[:mId] = second[:mId] = merged[:mId]
         # END do in later step
         
         first[:rules] = rules
         first[:match] = second[:id]
         second[:rules] = rules
         second[:match] = first[:id]
         @msplitter.insert_contrib_record first
         @msplitter.insert_contrib_record second
      elsif first[:mId].nil?
         first[:mId] = second[:mId]
         first[:rules] = rules
         first[:match] = second[:id]
         @msplitter.insert_contrib_record first
      elsif second[:mId].nil?
         second[:mId] = first[:mId]
         second[:rules] = rules
         second[:match] = first[:id]
         @msplitter.insert_contrib_record second
      else
         raise "Matched two inserted records. Sad."
      end
   end

   def match_record_threaded record, records
      high_score = 0
      pair = nil
      rules = nil

      threads = []
      record = record[:hash_map]
      records.split(7500) do |hunk|
         threads << Thread.new do
            accelerator = MergeAccelerator.new
            match_record record, hunk, accelerator
         end
      end

      threads.map do |thr|
         th_high, th_pair, th_rules =  thr.value
         if th_high > high_score and th_high > @threshold
            high_score = th_high
            pair = th_pair
            rules = th_rules
         end
      end
      [pair, rules]
   end
   def match_record record, hunk, accelerator
      high_score = 0
      pair = nil
      matched_rules = nil
      hunk.each do |other|
         if other[:id] == record.get(:id)
            next
         end
         score, rules, rule_values = accelerator.score_records @java_rules,
               record, other[:hash_map]
         if score > @threshold and high_score < score
            high_score = score
            pair = other
            matched_rules = {}
            rules.each_with_index do |rule_index, i|
               matched_rules[@config[rule_index]] = rule_values.get(i)
            end
         end
      end
      [high_score, pair, matched_rules]
   end

   def match_record_list list
      count = 0

      @java_rules = @config.map do |rule|
         java.util.HashMap.new(rule)
      end

      @java_rules.each do |rule|
         rule["fields"] = rule["fields"].to_java
      end
      
      list.each do |record|
         record[:hash_map] = java.util.HashMap.new(record)
      end

      list.each_with_index do |record, i|
         if record[:mId] != nil
            next
         end
         pair, rules = match_record_threaded record, list
         # TODO If a record matches a merged record, it should be combined into
         # a merge clump

         if pair
            puts "paired a record"
            merge_records record, pair, rules
         else
            @msplitter.insert_new_merge record
         end
         count += 1
         puts "#{count} records merged"
      end
      count
   end
end
