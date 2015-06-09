module Splitter
   class MergeSplitter
      def initialize db
         @db = db
      end

   def insert_new_merge record
      insert_merged_record record
      insert_contrib_record record
   end

   def insert_merged_record record
      insert_mprovider record
      case record[:type]
      when /individual/i
         insert_mindividual record
      when /organization/i
         insert_morganization record
      end
   end

   def insert_contrib_record record
      insert_merge record
      insert_multiple_parts record
      if record[:rules]
         record[:rules].each do |rule, score|
            insert_audit record, rule, score
         end
      else
         insert_no_rules_audit record
      end
   end

   def insert_mprovider record
      record[:mId] = @db.insert_mprovider record.filter [:type, :name_prefix,
            :name_first, :name_middle, :name_last, :name_suffix,
            :name_credential]
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

   def insert_audit record, rule, score
      audit = record.filter [:mId], {:id => :sId, :match => :other}
      audit[:rule] = "%s => %i" % [rule['fields'].to_s, rule['weight']]
      audit[:score] = score
      @db.insert_audit audit
   end

   def insert_no_rules_audit record
      audit = record.filter [:mId], {:id => :sId}
      audit[:rule] = "No rules matched"
      audit[:score] = -1
      audit[:other] = -1
      @db.insert_audit audit
   end

   def insert_multiple_parts record
      if not record[:phoneId].nil?
         @db.insert_provider_x_phone record.filter [:mId], {:phoneId => :phone}
      end
      if not record[:primarySpecialty].nil?
         @db.insert_provider_x_primary_specialty record.filter([:mId], {:primarySpecialty => :specialty})
      end
      if not record[:secondarySpecialty].nil?
         @db.insert_provider_x_secondary_specialty record.filter([:mId], {:secondarySpecialty => :specialty})
      end
      if not record[:mailingAddress].nil?
         @db.insert_provider_x_mailing_address record.filter([:mId], {:mailingAddress => :address})
      end
      if not record[:practiceAddress].nil?
         @db.insert_provider_x_practice_address record.filter([:mId], {:practiceAddress => :address})
      end
   end
   end
end
