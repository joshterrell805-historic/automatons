require 'text-table'

rows = []

open(ARGV[0]) do |io|
   io.each_line.each_with_index do |line, i|
      rows << line.split("\t").unshift(i)
   end
end

lengths = []
numbers = {}
rows.each do |row|
   lengths << row.length
   if numbers.key? row[1]
      puts "First: #{numbers[row[1]]}; Second: #{row[1]}: sid=#{row[1]}"
   end
   numbers[row[1]] = true
end

p lengths.uniq
