require 'psych'

module MDM
   class Record
      attr_reader :data
      attr_accessor :id, :type, :name, :gender, :dob,
         :sole_proprietor, :phone, :primary_specialty,
         :secondary_specialty

      def initialize data
         @data = Psych.parse(data).to_ruby
         @id = @data['ID']
         @type = @data['TYPE']
         @name = @data['NAME']
         @gender = @data['GENDER']
         @dob = @data['DateOfBirth']
         @sole_proprietor = @data['IS_SOLE_PROPRIETOR']
         @phone = @data['PRIMARY_PHONE']
         @primary_specialty = @data['PRIMARY_SPECIALTY']
         @secondary_specialty = @data['SECONDARY_SPECIALTY']
      end

      def clean
         clean_phone
      end

      def clean_phone
         case phone
         #when /(\d{3})\.(\d{3})\.(\d{4})/
         #   match = Regexp.last_match
         #   area, first, second = match[1..3]
         #when /\((\d{3})\) (\d{3})-(\d{4})/
         #   area, first, second = Regexp.last_match[1..3]
         when /(\d{3})-(\d{3})-(\d{4})/
            area, first, second = Regexp.last_match[1..3]
         #when /\d{10}/
         #   raise "Long"
         #else
            #raise "Sad face"
         end

         @phone = "(%s) %s-%s" % [area, first, second]
      end

      def update data
         changes = Psych.parse(data).to_ruby
         @data.merge! changes
      end

      def == other
         case other
         when Record
            data == other.data
         else
            false
         end
      end
   end
end
