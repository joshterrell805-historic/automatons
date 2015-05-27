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
class Database
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
   end

   def source_records
      @db[:SProvider]
   end

   def insert_source_record data
      @db[:SProvider].insert data
   end

   def insert_address data
      @db[:Address].check_insert :id, data
   end

   def insert_phone data
      @db[:PhoneNumber].check_insert :id, data
   end

   def insert_specialty data
      @db[:Specialty].check_insert :id, data
   end

   def insert_cprovider data
      @db[:CProvider].insert data
   end

   def insert_cindividual data
      @db[:CIndividual].insert data
   end

   def insert_corganization data
      @db[:COrganization].insert data
   end

   def cindividual_records start=nil
      data = @db[:CIndividual].join(:CProvider, [:id]).order(:id)
      if start
         data.where{id > start[:id]}
      else
         data
      end
   end

   def corganization_records start=nil
      data = @db[:COrganization].join(:CProvider, [:id]).order(:id)
      if start
         data.where{id > start[:id]}
      else
         data
      end
   end

   def insert_mprovider data
      @db[:MProvider].insert data
   end

   def insert_mindividual data
      @db[:MIndividual].insert data
   end

   def insert_merge data
      @db[:Merge].insert data
   end

   def insert_provider_x_phone data
      @db[:MProvider_PhoneNumber].check_insert [:mId, :phone], data
   end

   def insert_provider_x_primary_specialty data
      @db[:MProvider_PrimarySpecialty].check_insert [:mId, :specialty], data
   end

   def insert_provider_x_secondary_specialty data
      @db[:MProvider_SecondarySpecialty].check_insert [:mId, :specialty], data
   end

   def insert_provider_x_mailing_address data
      @db[:MProvider_MailingAddress].check_insert [:mId, :address], data
   end

   def insert_provider_x_practice_address data
      @db[:MProvider_PracticeAddress].check_insert [:mId, :address], data
   end

   def insert_audit data
      @db[:Audit].insert data
   end

   ## Sources the given file into the DB
   # Happens in an instance of the MySQL command-line client, rather than over
   # the DB connection here. Will act on the DB this object is connected to.
   def source file
      @client.run in: file
   end

   ## Return the Sequel instance used by this Database.
   def sequel
      @db
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

   ## Runs the MySQL client with options
   #
   # Makes it easy to do things like sourcing a file into the DB
   # @param args Options as for Kernel#spawn
   def run *args
      system *command, *args
   end
end
