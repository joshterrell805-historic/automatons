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

      open("cleanse-results.yaml", 'w') do |log|
         Psych.dump @cleanser.missing, log
      end

      count
   end

   ## Merges all the records it can from the database
   def merge
      record_id = :id

      done = {}
      count = 0
      @db.cindividual_records.each do |record|
         # Skip already-merged records
         if done[record]
            next
         end

         # Returns best matching record, or nil if none were over the threshold
         pair = match_record :indiv, record
         if pair
            merge_records :indiv, record, pair
            done[pair] = true
         else
            @msplitter.insert_new_merge :indiv, record
         end
         count += 1
      end

      @db.corganization_records.each do |record|
         # Skip already-merged records
         if done[record]
            next
         end

         # Returns best matching record, or nil if none were over the threshold
         pair = match_record :org, record
         if pair
            merge_records :org, record, pair
            done[pair] = true
         else
            @msplitter.insert_new_merge :org, record
         end
         count += 1
      end

      count
   end

   def match_record type, record
      case type
      when :indiv
         records = @db.cindividual_records(record)
      when :org
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

   def merge_records type, first, second
      second[:mId] = @msplitter.insert_mprovider first

      @msplitter.insert_merge first
      @msplitter.insert_merge second

      case type
      when :indiv
         @msplitter.insert_mindividual first
      when :org
         @msplitter.insert_morganization first
      end

      @msplitter.insert_multiple_parts first
      @msplitter.insert_audit first, "merge duplicate records"

      @msplitter.insert_multiple_parts second
      @msplitter.insert_audit second, "merge duplicate records"
   end
end
