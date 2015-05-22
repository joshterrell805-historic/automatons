module Rules

   # run a rule against each field that matches regex
   Each = Struct.new :regex, :name, :block
   class Each
      def run data
         data.each do |key, value|
	    next unless value.is_a? String

            regex = self[:regex]

            if regex
               match = regex.match value
            else
               match = value
            end

            # match will be nil if data[field] is nil or if there is no match
            # We have to also check the regex, because rules which run on
            # everything should run when the data is nil, and since match will
            # be the data when regex is nil, we'll need to run anyway in that
            # case.
            if match or not regex
               data[key] = self[:block].call match
            end
            data
         end
      end
   end
end
