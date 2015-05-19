require 'docopt'
require 'sequel'
require_relative '../lib/database.rb'
require 'hash'

Sequel.extension :check_insert

class Main
   # Attributes to store the database object and the cleanser
   def initialize db, cleanser
      @db = db
      @cleanser = cleanser
   end

   def run argv
      doc = "
      Automatons DataMaster

      Usage:
       app (--cleanse)
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
   end

   def cleanse
      records = @db[:SProvider]
      count = 0
      records.each do |record|
         cleansed = @cleanser.cleanse record

         insert_phone record
         insert_address record
         insert_specialty record
         insert_cprovider record
         case record[:type]
         when /individual/i
            insert_cindividual record
         when /organization/i
            insert_corganization record
         else
            raise "Unexpected record type: #{record[:id]} has type '#{record[:type]}'"
         end

         count += 1
         if count % 100 == 0
	    puts "Cleansed #{count} record#{count != 1 ? 's' : ''}"
	 end
      end

      count
   end

   def insert_phone record
      data = record.filter [:phone]
      id = @db[:PhoneNumber].check_insert :id, data
      record[:phone_id] = id
   end

   def insert_address record
      source = [
         :mStreet,
         :mUnit,
         :mCity,
         :mRegion,
         :mPostCode,
         :mCounty,
         :mCountry]

      source2 = [
         :pStreet,
         :pUnit,
         :pCity,
         :pRegion,
         :pPostCode,
         :pCounty,
         :pCountry]

      destination = [
         :street,
         :unit,
         :city,
         :region,
         :postcode,
         :county,
         :country]

      data = record.filter source, destination
      data2 = record.filter source2, destination
      id = @db[:Address].check_insert :id, data
      id2 = @db[:Address].check_insert :id, data2
      record[:mAddress_id] = id
      record[:pAddress_id] = id2
   end

   def insert_specialty record
      source = [:primarySpecialty]
      source2 = [:secondarySpecialty]
      dest = [:code]
      data = record.filter source, dest
      data2 = record.filter source2, dest
      id = @db[:Specialty].check_insert :id, data
      id2 = @db[:Specialty].check_insert :id, data2
      record[:primarySpecialty_id] = id
      record[:secondarySpecialty_id] = id
   end

   def insert_cprovider record
      source = [
         :id,
         :type,
         :name
      ]
      data = record.filter source, {mAddress_id: :mailingAddress, pAddress_id: :practiceAddress, phone_id: :phone, primarySpecialty_id: :primarySpecialty, secondarySpecialty_id: :secondarySpecialty}
      @db[:CProvider].insert data
   end

   def insert_cindividual record
      source = [
         :gender,
         :dateOfBirth,
         :isSoleProprietor,
         :id
      ]
      data = record.filter source
      id = @db[:CIndividual].insert data
      record[:cIndividual_id] = id
   end

   def insert_corganization record
      source = [
         :id
      ]
      data = record.filter source
      id = @db[:COrganization].insert data
      record[:cOrganization_id] = id
   end
end
