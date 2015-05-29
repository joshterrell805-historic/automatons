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
      points_total = 0
      @config.each do |rule|
         skipped = 0
         if rule['fields'] == 'all'
           fields = record.keys
         else
           fields = rule['fields']
         end
         score_sum = 0
         fields.map do |field|
            val1 = record[field]
            val2 = other[field]
            if val1.nil? or val2.nil?
               skipped += 1
               next 0
            end
            score_sum += edit_dist(val1, val2)
         end

         if fields.length > skipped
            avg_score = Rational score_sum, fields.length-skipped
            weight = rule['weight']
            points_possible += weight
            points_total += avg_score * weight
         else
            0
         end
      end
      points_total/points_possible
   end

   ## Returns a value between 0 and 1, with 0 being completely
   #dissimilar, and 1 being identical
   def edit_dist val1, val2
      val1 == val2 ? 1 : 0
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

   def match_record record
      case record[:type]
      when /individual/i
         records = @db.cindividual_records(record)
      when /organization/i
         records = @db.corganization_records(record)
      end

      high_score = 0
      pair = nil

      total_points_possible = 0
      points_per_record = {}
      records.each do |other|
         points_per_record[other[:id]] = 0
      end

      max_points = 0
      pair = nil

      @config.each do |rule|
         if rule['fields'] == 'all'
            fields = record.keys
         else
            fields = rule['fields']
         end

         num = fields.length
         field_points_per_record = {}
         records.select_map(:id).each do |other|
            field_points_per_record[other] = [0, num]
         end
         skipped = 0
         fields.each do |field|
            val1 = record[field]
            if val1.nil?
               skipped += 1
               next
            end
            records.each do |other|
               rid = other[:id]
               val2 = other[field]
               if val2.nil?
                  field_points_per_record[rid][1] -= 1
                  next
               end
               field_points_per_record[rid][0] += edit_dist(val1, val2)
            end
         end

         weight = rule['weight']
         total_points_possible += weight

         field_points_per_record.each do |key, value|
            if value[1] > skipped
               score = Rational value[0]*weight, value[1]-skipped
               points_per_record[key] += score
               if score > high_score
                  high_score = score
                  pair = key
               end
            end
         end
      end
      records.where(:id => pair).first
   end

   def match_record_list records
      count = 0
      done = {}
      records.each do |record|
         # Skip already-merged records
         if done[record]
            next
         end

         # Returns best matching record, or nil if none were over the threshold
         pair = match_record record
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
