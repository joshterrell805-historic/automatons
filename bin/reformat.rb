require 'yaml'

# reformat.rb
# Dumps the data from TSV files on the command line as YAML

# First, we parse the input file
rows = nil
open(ARGV[0]) do |io|
   headers = io.readline.rstrip.split("\t")
   rows = io.map do |line|
      headers.zip(line.rstrip.split("\t")).to_h
   end
end

# Then we stream the resulting YAML out
stream = Psych::Stream.new $stdout
stream.start do |em|
   em.push(rows)
end
