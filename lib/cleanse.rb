require 'sequel'

DB = Sequel.connect 
DB.fetch("SELECT * FROM SProvider") do |row|
   cleansed = cleanse row
   insert cleansed
end

class CleanRecord
   CProviderAttrib = %w[
    id
    type
    name
    phone
    billingAddress
    mailingAddress
    primarySpecialty
    secondarySpecialty
   ]

   def initialize row
      @row = row
   end

   def insert
      @cid = insert_cprovider

      if is_individual?
         insert_individual
      else
         insert_organization
      end

      insert_phone
      insert_address
   end

   def insert_cprovider
      cproviders.insert {
         id: @row[:id],
         type: @row[:type],
         name: @row[:name],
         phone: @row[:phone],
         billingAddress: @billing,
         mailingAddress: @mailing,
         primarySpecialty: find_specialty(@row[:primarySpecialty]),
         secondarySpecialty: find_specialty(@row[:secondarySpecialty])
      }
   end
end
