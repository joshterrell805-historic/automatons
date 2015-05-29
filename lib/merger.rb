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
         ret = rule['fields'].reduce(0) do |score, field|
            val1 = record[field.to_sym]
            val2 = other[field.to_sym]
            score + edit_dist(val1, val2)
         end

         ret /= rule['fields'].length.to_r
         weight = rule['weight']
         points_possible += weight
         points_total + ret * weight
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

      records.each do |other|
         score = score_records record, other
         if high_score < score
            high_score = score
            pair = other
         end
      end
      pair
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
      end
      count
   end
end
# for cprovider in CProvider

  # if MProviders if empty
    # create new master record with cprovider
    # continue

  # for mprovider in MProvider
    # establishing confidence for each cprovider-mprovider using all match rules

  # select highest confidence

  # if confidence >= threshold
    # merge cprovider with mprovider
    # logging which rules passed
  # else
    # create new master record with cprovider
#
# And in Ruby...
#THRESHOLD = 0 # Set this to the threshold
#CProvider.each do |cprovider|
#  # This is assuming MProviders is an array
#  if MProviders.empty?
#    create_master_record cprovider
#    next
#  end
#
#  MProviders.each do |mprovider|
#    # establish confidence confidence
#    # select highest confidence
#    if confidence >= THRESHOLD
#      merge_records mprovider, cprovider
#      log_merge mprovider, cprovider
#      # Although perhaps this would be in the merge_records
#    else
#      add_new_mprovider
#    end
#  end
#end
