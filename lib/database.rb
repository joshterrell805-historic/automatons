require 'delegate'
require 'sequel'

module SQLConfig
   def set_from_env
      # Init class from environment
      @host     = ENV["mysql_host"]
      @database = ENV["mysql_database"]
      @password = ENV["mysql_password"]
      @user     = ENV["mysql_user"]
   end
end

##
# This class provides a convenient way to get access to the database. It will
# read the correct environment variables to find where it is supposed to be
# connecting.
class Database < Delegator
   include SQLConfig

   def initialize
      # Init class from environment
      set_from_env

      # @client allows us to run a SQL client with the settings from this
      # Database class
      @client = SQLClient.new
      @db = Sequel.connect adapter: 'mysql2',
         host:     @host,
         database: @database,
         password: @password,
         user:     @user

      super @db
   end

   def __getobj__
      @db
   end

   def __setobj__ obj
      @db = obj
   end

   ## Sources the given file into the DB
   # Happens in an instance of the MySQL command-line client, rather than over
   # the DB connection here. Will act on the DB this object is connected to.
   def source file
      @client.run in: file
   end

end

class SQLClient
   include SQLConfig
   def initialize
      set_from_env
   end

   def command
      ['mysql',
       '--user', @user,
       '--password=' + @password,
       '--host', @host,
       '--database', @database]
   end

   ## Runs the MySQL client and accepts options as for Kernel#spawn
   def run *args
      system *command, *args
   end
end
