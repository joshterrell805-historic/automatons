require 'bundler/setup'
require 'rake/clean'

require_relative 'lib/env'
require_relative 'lib/database'

require 'dotenv'
# Load any environment variables which aren't defined
# Take values from ".env"
Dotenv.load

BIN = File.absolute_path './bin'
ENV["PATH"] += BIN


task default: [:loadDB]
task loadDB: [:loadProviders, :loadSpecialties]

desc "Load the raw Providers into the database"
task :loadProviders => :create do
   sh "node #{BIN}/insert-providers.js Providers.tsv"
end

desc "Load the raw Specialties into the database"
task :loadSpecialties => :create do
   sh "node #{BIN}/insert-specialties.js Specialties.tsv"
end

desc "Run tests"
task test: [:rspec, :cucumber]

task :cucumber => :test_create do
   sh "cucumber --format progress"
end

task :rspec do
   sh "rspec --format progress"
end

task :create do
   mysql in: "DB-setup.sql"
end

task :clean => :test_clean do
   mysql in: "DB-truncate-clean.sql"
end

task :clobber => :test_clobber do
   mysql in: "DB-cleanup.sql"
end

task :test_clobber do
   with_test_env do
      mysql in: "DB-cleanup.sql"
   end
end

task :test_create do
   with_test_env do
      mysql in: "DB-setup.sql"
   end
end

task :test_clean do
   with_test_env do
      mysql in: "DB-truncate-clean.sql"
   end
end

def with_test_env
   in_separate_environment do
      # Overwrite environment variables with values for testing
      Dotenv.overload '.env.test'
      yield
   end
end

def mysql *arg
   client = SQLClient.new
   puts (client.command + arg).join(' ')
   client.run *arg
end
