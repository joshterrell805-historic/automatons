require 'docopt'
require 'sequel'
require_relative '../lib/database.rb'

class Main
   # Attributes to store the database object and the cleanser
   def initialize db, cleanser
      @db = db
      @cleanser = cleanser
   end

   def run argv
      doc = "
      Automatons' DataMaster

      Usage:
       app (--cleanse)
       app --help

      Options:
       --help  Print this message
      "

      begin
         opts = Docopt::docopt(doc)
      rescue Docopt::Exit => e
         puts e.message
         exit 2
      end

      if opts['--cleanse']
      end
   end

   def cleanse
      @db[:SProvider].each do |record|
         cleansed = @cleanser.cleanse record
         #@db[:PhoneNumber].insert cleansed.values_at 
      end
   end
end
