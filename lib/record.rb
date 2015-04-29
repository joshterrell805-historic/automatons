require 'psych'

module MDM
   class Record
      attr_reader :data

      def initialize data
         @data = Psych.parse(data).to_ruby
      end

      def clean

      end

      def update data
         changes = Psych.parse(data).to_ruby
         @data.merge! changes
      end
   end
end
