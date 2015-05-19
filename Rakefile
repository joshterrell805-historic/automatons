require 'bundler/setup'
require 'rake/clean'
require 'dotenv'
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

task :cucumber do
   sh "cucumber --format progress"
end

task :rspec do
   sh "rspec --format progress"
end

task :create do
   sh "#{mysql} < DB-setup.sql"
end

task :clean do
   sh "#{mysql} < DB-truncate-clean.sql"
end

task :clobber do
   sh "#{mysql} < DB-cleanup.sql"
end

def mysql
   "mysql -u #{ENV['mysql_user']} -p'#{ENV['mysql_password']}' -h #{ENV['mysql_host']} --database #{ENV['mysql_database']}"
end
