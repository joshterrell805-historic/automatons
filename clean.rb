require 'sequel'

DB = Sequel.connect ""
results = DB.fetch("SELECT * FROM SProvider") do |row|
   # ###.###.####
   # (###) ###-####
   # ###-###-####
   # ##########
   phone = row[:phone]
   #match = /(\d{3}\.\d{
   case phone
   when /(\d{3})\.(\d{3})\.(\d{4})/
      match = Regexp.last_match
      area, first, second = match[1..3]
   when /\((\d{3})\) (\d{3})-(\d{4})/
      match = Regexp.last_match
      area, first, second = match[1..3]
   when /(\d{3})-(\d{3})-(\d{4})/
      match = Regexp.last_match
      area, first, second = match[1..3]
   when /\d{10}/
      raise "Long"
   else
      raise "Sad face"
   end

   puts "(%s) %s-%s" % [area, first, second]
end


