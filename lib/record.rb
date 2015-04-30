require 'psych'

module MDM
   Record = Struct.new :id, :type, :name, :gender, :dob,
         :sole_proprietor, :phone, :primary_specialty,
         :secondary_specialty
   class Record
      attr_reader :data

      def initialize data
         data = Psych.parse(data).to_ruby
         load data
      end

      def load data
         @data = data
         self['id'] = @data['ID']
         self['type'] = @data['TYPE']
         self['name'] = @data['NAME']
         self['gender'] = @data['GENDER']
         self['dob'] = @data['DateOfBirth']
         self['sole_proprietor'] = @data['IS_SOLE_PROPRIETOR']
         self['phone'] = @data['PRIMARY_PHONE']
         self['primary_specialty'] = @data['PRIMARY_SPECIALTY']
         self['secondary_specialty'] = @data['SECONDARY_SPECIALTY']
      end

      def clean
         clean_phone
      end

      def clean_phone
         case phone
         #when /(\d{3})\.(\d{3})\.(\d{4})/
         #   match = Regexp.last_match
         #   area, first, second = match[1..3]
         when /\((\d{3})\) (\d{3})-(\d{4})(?: \[x(\d+)\])?/
            area, first, second, ext = Regexp.last_match[1..4]
         when /(\d{3})-(\d{3})-(\d{4})/
            area, first, second = Regexp.last_match[1..3]
         #when /\d{10}/
         #   raise "Long"
         #else
            #raise "Sad face"
         end

         phone = "(%s) %s-%s" % [area, first, second]
         if ext
            phone += " [x%s]" % ext
         end
         self[:phone] = phone
      end

      def update data
         changes = Psych.parse(data).to_ruby
         load @data.merge changes
      end
   end
end
