require 'docopt'
require 'sequel'
require 'psych'
require_relative '../lib/database.rb'
require 'hash'
require 'clean-splitter'
require 'merge-splitter'
require 'merger'

Sequel.extension :check_insert

class Main
   # Attributes to store the database object and the cleanser
   def initialize db, cleanser
      @db = db
      @cleanser = cleanser
      @csplitter = Splitter::CleanSplitter.new @db
      @msplitter = Splitter::MergeSplitter.new @db
      @merger = Merger.new @db
   end

   def run argv
      doc = "
      Automatons DataMaster

      Usage:
       app (--cleanse|--merge)
       app --help

      Options:
       --help  Print this message
      "

      begin
         opts = Docopt::docopt(doc)
      rescue Docopt::Exit => e
         puts e.message
         exit 2
      end

      if opts['--cleanse']
         count = cleanse
         puts "Cleansed #{count} record#{count != 1 ? 's' : ''}"
      end

      if opts['--merge']
         count = merge
         puts "Merged #{count} record#{count != 1 ? 's' : ''}"
      end
   end

   def cleanse
      records = @db.source_records
      count = 0
      records.each do |record|
         cleansed = @cleanser.cleanse record

         @csplitter.insert_cleansed record

         count += 1
         if count % 100 == 0
	    puts "Cleansed #{count} record#{count != 1 ? 's' : ''}"
	 end
      end

      count
   end

   ## Merges all the records it can from the database
   def merge
      count = 0
      count += match_record_list @db.cindividual_records
      count += match_record_list @db.corganization_records
      count
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
      count end

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
         score = @merger.score_records record, other
         if high_score < score
            high_score = score
            pair = other
         end
      end
      pair
   end

   def merge_records first, second
      merged = first
      merge_reason = "merge duplicate records"

      @msplitter.insert_merged_record merged
      first[:mId] = second[:mId] = merged[:mId]

      @msplitter.insert_contrib_record first, merge_reason
      @msplitter.insert_contrib_record second, merge_reason
   end
end
