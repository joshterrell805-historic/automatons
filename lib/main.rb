require 'docopt'
require 'sequel'
require 'psych'
require_relative '../lib/database.rb'
require 'hash'
require 'clean-splitter'

Sequel.extension :check_insert

class Main
   # Attributes to store the database object and the cleanser
   def initialize db, cleanser
      @db = db
      @cleanser = cleanser
      @csplitter = Splitter::CleanSplitter.new @db
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

         @csplitter.insert_phone record
         @csplitter.insert_address record
         @csplitter.insert_specialty record
         @csplitter.insert_cprovider record
         @csplitter.insert_cprovidertype record

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
            merge_records record, pair
            done[pair] = true
         else
            insert_new_merge record
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
            merge_records record, pair
            done[pair] = true
         else
            insert_new_merge record
         end
         count += 1
      end

      count
   end

   def match_record type, record
      high_score = 0
      pair = nil
      case type
      when :indiv
         @db.cindividual_records(record).each do |other|
            score = 0
            record.each do |key, value|
               o_val = other[key]
               case key
               when :id
                  if o_val == value
                     score -= 5
                  end
               else
                  score += 1 if o_val == value
               end
            end
            if high_score < score
               high_score = score
               pair = other
            end
         end
      when :org
         @db.corganization_records(record).each do |other|
            score = 0
            record.each do |key, value|
               o_val = other[key]
               case key
               when :id
                  if o_val == value
                     score -= 5
                  end
               else
                  score += 1 if o_val == value
               end
            end
            if high_score < score
               high_score = score
               pair = other
            end
         end
      end

      pair
   end

   def merge_records first, second
      first[:mId] = second[:mId] = @db.insert_mprovider first.filter [:type, :name]

      map = {:id => :sId, :mId => :mId}
      @db.insert_merge first.filter map
      @db.insert_merge second.filter map

      @db.insert_mindividual first.filter([:gender, :dateOfBirth, :isSoleProprietor], {:mId => :id})

      phone = [:mId, :phone]
      @db.insert_provider_x_phone first.filter phone
      @db.insert_provider_x_phone second.filter phone

      @db.insert_provider_x_primary_specialty first.filter([:mId], {:primarySpecialty => :specialty})
      @db.insert_provider_x_primary_specialty second.filter([:mId], {:primarySpecialty => :specialty})

      @db.insert_provider_x_secondary_specialty first.filter([:mId], {:secondarySpecialty => :specialty})
      @db.insert_provider_x_secondary_specialty second.filter([:mId], {:secondarySpecialty => :specialty})

      @db.insert_provider_x_mailing_address first.filter([:mId], {:mailingAddress => :address})
      @db.insert_provider_x_mailing_address second.filter([:mId], {:mailingAddress => :address})

      @db.insert_provider_x_practice_address first.filter([:mId], {:practiceAddress => :address})
      @db.insert_provider_x_practice_address second.filter([:mId], {:practiceAddress => :address})
      
      audit1 = first.filter [:mId], {:id => :sId}
      audit1[:action] = "merge duplicate records"

      audit2 = second.filter [:mId], {:id => :sId}
      audit2[:action] = "merge duplicate records"

      @db.insert_audit audit1
      @db.insert_audit audit2
   end

   def insert_new_merge record
      record[:mId] = @db.insert_mprovider record.filter [:type, :name]

      map = {:id => :sId, :mId => :mId}
      @db.insert_merge record.filter map

      @db.insert_mindividual record.filter([:gender, :dateOfBirth, :isSoleProprietor], {:mId => :id})

      phone = [:mId, :phone]
      @db.insert_provider_x_phone record.filter phone

      @db.insert_provider_x_primary_specialty record.filter([:mId], {:primarySpecialty => :specialty})

      @db.insert_provider_x_secondary_specialty record.filter([:mId], {:secondarySpecialty => :specialty})

      @db.insert_provider_x_mailing_address record.filter([:mId], {:mailingAddress => :address})

      @db.insert_provider_x_practice_address record.filter([:mId], {:practiceAddress => :address})
      
      audit1 = record.filter [:mId], {:id => :sId}
      audit1[:action] = "Done"

      @db.insert_audit audit1
   end
   end
end
