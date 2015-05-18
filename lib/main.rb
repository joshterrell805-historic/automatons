require 'docopt'
require 'sequel'
require_relative '../lib/database.rb'

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
      end

      count
   end

   def insert_phone record
      data = Main.filter_data record, [:phone]
      id = check_insert :PhoneNumber, :id, data
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

      data = Main.filter_data record, source, destination
      data2 = Main.filter_data record, source2, destination
      id = check_insert :Address, :id, data
      id2 = check_insert :Address, :id, data2
      record[:mAddress_id] = id
      record[:pAddress_id] = id2
   end

   def insert_specialty record
      source = [:primarySpecialty]
      source2 = [:secondarySpecialty]
      dest = [:code]
      data = Main.filter_data record, source, dest
      data2 = Main.filter_data record, source2, dest
      id = check_insert :Specialty, :id, data
      id2 = check_insert :Specialty, :id, data2
      record[:primarySpecialty_id] = id
      record[:secondarySpecialty_id] = id
   end

   def insert_cprovider record
      source = [
         :id,
         :type,
         :name
      ]
      data = Main.filter_data record, source, {mAddress_id: :mailingAddress, pAddress_id: :practiceAddress, phone_id: :phone, primarySpecialty_id: :primarySpecialty, secondarySpecialty_id: :secondarySpecialty}
      @db[:CProvider].insert data
   end

   def insert_cindividual record
      source = [
         :gender,
         :dateOfBirth,
         :isSoleProprietor,
         :id
      ]
      data = Main.filter_data record, source
      id = @db[:CIndividual].insert data
      record[:cIndividual_id] = id
   end

   def insert_corganization record
      source = [
         :id
      ]
      data = Main.filter_data record, source
      id = @db[:COrganization].insert data
      record[:cOrganization_id] = id
   end

   def check_insert table, id, data
      @db[table].where(data).get(id) or
         @db[table].insert data
   end

   def Main.filter_data data, *filters
      result = {}

      first = nil
      filters.each do |filter|
         case filter
         when Array
            if first
               first.zip(filter).each do |pair|
                  result[pair.last] = data[pair.first]
               end
               first = nil
            else
               first = filter
            end
         when Hash
            if first
               first.each do |key|
                  result[key] = data[key]
               end
               first = nil
            end

            filter.each do |source_key, result_key|
               result[result_key] = data[source_key]
            end
         end
      end

      if first
         first.each do |key|
            result[key] = data[key]
         end
         first = nil
      end
      result
   end
end
