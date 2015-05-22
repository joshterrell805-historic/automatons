module Rules
   Rule = Struct.new :field, :regex, :name, :block
   class Rule
      def run data
         field = self[:field]
         regex = self[:regex]

         if regex
            match = regex.match data[field]
         else
            match = data[field]
         end

         # match will be nil if data[field] is nil or if there is no match
         # We have to also check the regex, because rules which run on
         # everything should run when the data is nil, and since match will
         # be the data when regex is nil, we'll need to run anyway in that
         # case.
         if match or not regex
            data[field] = self[:block].call match
         end
         data
      end
   end
end
