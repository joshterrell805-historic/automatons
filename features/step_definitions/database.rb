require 'database'

Given /^an empty database$/ do
   @db = Database.new
   Dotenv.load ".env.test"
   @db.source "DB-truncate.sql"
   #@db.source "DB-cleanup.sql"
   #@db.source "DB-setup.sql"
end
