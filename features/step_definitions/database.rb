require 'database'

Given /^an empty database$/ do
   @db = Database.new
   @db.source "DB-truncate-source.sql"
   #@db.source "DB-cleanup.sql"
   #@db.source "DB-setup.sql"
end

Given /^(a|\d+) standard (individual|organization) source record(?:s?) in SProvider$/ do |count, type|
   case count
   when /a/
      count = 1
   else
      count = count.to_i
   end

   table = @db[:SProvider]
   1.upto(count.to_i) do |i|
      record = Example.get_standard_record
      record['id'] = record['id'].to_i + i-1
      record['type'] = type

      table.insert record
   end
end

Then /^the "(.*?)" table should contain:$/ do |table, yaml|
   expected = Psych.parse(yaml).to_ruby
   data = {}

   # Convert string keys to symbol keys
   expected.each do |key, value|
      data[key.to_sym] = value
   end

   dataset = @db[table.to_sym]

   expect(dataset.where(data).count).to eq(1)
end
