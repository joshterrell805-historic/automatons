require 'psych'
class Merger
   attr_accessor :config
   def initialize db
      @db = db
      @msplitter = Splitter::MergeSplitter.new db
      @config = [{'fields' => 'all', 'weight' => 1}]
   end

   def score_records record, other
      points_possible = 0
      points_total = @config.reduce(0) do |points_total, rule|
         weight = rule['weight']
         fields = rule['fields']

         ret = fields.reduce(0) do |score, field|
            sym = field.to_sym
            val1 = record[sym]
            val2 = other[sym]
            score + edit_dist(weight, val1, val2)
         end

         ret /= fields.length.to_f
         points_possible += weight
         points_total + ret
      end
      points_total/points_possible
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
      merged = first
      merge_reason = "merge duplicate records"

      @msplitter.insert_merged_record merged
      first[:mId] = second[:mId] = merged[:mId]

      @msplitter.insert_contrib_record first, merge_reason
      @msplitter.insert_contrib_record second, merge_reason
   end

   def match_record record, records, i
      high_score = 0
      pair = nil

      ((i+1)...records.length).each do |i|
         other = records[i]
         score = score_records record, other
         if high_score < score
            high_score = score
            pair = other
         end
      end
      pair
   end

   def match_record_list list
      count = 0
      done = {}
      list.each_with_index do |record, i|
         # Skip already-merged records
         if done[record]
            next
         end

         pair = match_record record, list, i
         if pair
            merge_records record, pair
            done[pair] = true
         else
            @msplitter.insert_new_merge record
         end
         count += 1
         puts "#{count} records merged"
      end
      count
   end
end
