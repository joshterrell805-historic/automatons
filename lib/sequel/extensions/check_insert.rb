class Sequel::Dataset
   def check_insert id, data
      where(data).get(id) or
         insert data
   end
end
