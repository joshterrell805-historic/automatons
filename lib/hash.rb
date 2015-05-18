class Hash
   def filter *filters
      result = {}

      first = nil
      filters.each do |filter|
         case filter
         when Array
            if first
               first.zip(filter).each do |pair|
                  result[pair.last] = self[pair.first]
               end
               first = nil
            else
               first = filter
            end
         when Hash
            if first
               first.each do |key|
                  result[key] = self[key]
               end
               first = nil
            end

            filter.each do |source_key, result_key|
               result[result_key] = self[source_key]
            end
         end
      end

      if first
         first.each do |key|
            result[key] = self[key]
         end
         first = nil
      end
      result
   end
end
