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
      @merger = Merger.new @db
      config = Psych.load_file "table.yaml"
      config.map do |rule|
         rule['fields'] = rule['fields'].map {|f| f.to_sym}
      end
      @merger.config = config
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
      count += @merger.match_record_list @db.cindividual_records.all
      count += @merger.match_record_list @db.corganization_records.all
      count
   end
end
