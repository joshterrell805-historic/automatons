module Splitter
   class CleanSplitter
      def initialize db
         @db = db
      end

      def insert_cleansed record
         insert_phone record
         insert_address record
         insert_specialty record
         insert_cprovider record
         insert_cprovidertype record
      end

      def insert_phone record
         if not record[:phone].nil?
            data = record.filter [:phone]
            id = @db.insert_phone data
         else
            id = nil
         end
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
         record[:mAddress_id] = @db.insert_address data
         record[:pAddress_id] = @db.insert_address data2
      end

      def insert_specialty record
         source = [:primarySpecialty]
         source2 = [:secondarySpecialty]
         dest = [:code]
         data = record.filter source, dest
         data2 = record.filter source2, dest
         record[:primarySpecialty_id] = @db.insert_specialty data
         record[:secondarySpecialty_id] = @db.insert_specialty data2
      end

      def insert_cprovider record
         source = [
            :id,
            :type,
            :name
         ]
         data = record.filter source, {mAddress_id: :mailingAddress, pAddress_id: :practiceAddress, phone_id: :phone, primarySpecialty_id: :primarySpecialty, secondarySpecialty_id: :secondarySpecialty}
         @db.insert_cprovider data
      end

      def insert_cprovidertype record
         case record[:type]
         when /individual/i
            insert_cindividual record
         when /organization/i
            insert_corganization record
         else
            raise "Unexpected record type: #{record[:id]} has type '#{record[:type]}'"
         end
      end

      def insert_cindividual record
         source = [
            :gender,
            :dateOfBirth,
            :isSoleProprietor,
            :id
         ]
         data = record.filter source
         record[:cIndividual_id] = @db.insert_cindividual data
      end

      def insert_corganization record
         source = [
            :id
         ]
         data = record.filter source
         record[:cOrganization_id] = @db.insert_corganization data
      end
   end
end
