require 'yaml'

numbers = {}
audit = []
$<.each_line do |line|
   row = line.split("\t")
   if numbers.key? row[0]
      newnumber = (row[0].to_i) + 1
      audit << {"from" => row[0].to_i, "to" => newnumber}
      row[0] = newnumber
   end
   puts row.join("\t")
   numbers[row[0]] = true
end

open("audit.log", "w") do |io|
   io.puts YAML.dump(audit)
end
