class Merger
   def initialize db
      @db = db
      @msplitter = Splitter::MergeSplitter.new db
   end

   def score_records record, other
      score = 0
      record.each do |key, value|
         o_val = other[key]
         res = score_pair key, value, o_val
         score += res || 0
      end
      score
   end

   def score_pair key, val1, val2
      case key
      when :id
         if val2 == val1
            -5
         end
      else
         1 if val2 == val1
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
