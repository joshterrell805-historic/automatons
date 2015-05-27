module Splitter
   class MergeSplitter
      def initialize db
         @db = db
      end

   def insert_new_merge type, record
      insert_mprovider record
      insert_merge record
      case type
      when :indiv
         insert_mindividual record
      when :org
         insert_morganization record
      end
      insert_multiple_parts record
      insert_audit record, "copy record"
   end

   def insert_mprovider record
      record[:mId] = @db.insert_mprovider record.filter [:type, :name]
   end

   def insert_merge record
      map = {:id => :sId, :mId => :mId}
      @db.insert_merge record.filter map
   end

   def insert_mindividual record
      @db.insert_mindividual record.filter([:gender, :dateOfBirth, :isSoleProprietor], {:mId => :id})
   end

   def insert_morganization record
      @db.insert_morganization record.filter({:mId => :id})
   end

   def insert_audit record, description
      audit = record.filter [:mId], {:id => :sId}
      audit[:action] = description
      @db.insert_audit audit
   end

   def insert_multiple_parts record
      @db.insert_provider_x_phone record.filter [:mId, :phone]
      @db.insert_provider_x_primary_specialty record.filter([:mId], {:primarySpecialty => :specialty})
      @db.insert_provider_x_secondary_specialty record.filter([:mId], {:secondarySpecialty => :specialty})
      @db.insert_provider_x_mailing_address record.filter([:mId], {:mailingAddress => :address})
      @db.insert_provider_x_practice_address record.filter([:mId], {:practiceAddress => :address})
   end
   end
end
