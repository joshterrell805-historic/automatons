require 'delegate'
require 'sequel'

##
# This class provides a convenient way to get access to the database. It will
# read the correct environment variables to find where it is supposed to be
# connecting.
class Database < Delegator

   def initialize
      @db = Sequel.connect adapter: 'mysql2',
         host: ENV["mysql_host"],
         database: ENV["mysql_database"],
         password: ENV["mysql_password"],
         user: ENV["mysql_user"]

      super @db
   end

   def __getobj__
      @db
   end

   def __setobj__ obj
      @db = obj
   end

   ## Sources the given file into the DB
   def source file
      open(file) do |reader|
         reader.map{|line| line.gsub /--.*$/, ''}.join.split(';').each do |sql|
            if not sql.strip.empty?
               begin
               # Run the SQL on the DB
               run sql
               rescue => e
                  p sql
                  raise e
               end
            end
         end
      end
   end
end
