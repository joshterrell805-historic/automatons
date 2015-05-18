require 'database'

Given /^an empty database$/ do
   @db = Database.new
   Dotenv.load ".env.test"
   @db.source "DB-truncate.sql"
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
   table = @db[table.to_sym]

   q = expected.reduce(table) do |query, pair|
      query.where(pair.first.to_sym => pair.last)
   end

   expect(q.count).to eq(1)
end
