class Array
   def split n
      max = length

      i = 0
      while i+n < max
         yield self[i..i+n]
         i += n
      end

      if i < max
         yield self[i..-1]
      end
   end
end
