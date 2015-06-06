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


task default: :full_merge
task full_merge: [:full_cleanse, :build] do
   with_jruby do
      sh "bin/app --merge"
   end
end

task full_cleanse: [:loadDB, :build] do
   with_jruby do
      sh "bin/app --cleanse"
   end
end

task cleanse: :build do
   with_jruby do
      sh "bin/app --cleanse"
   end
end

task merge: :build do
   with_jruby do
      sh "bin/app --merge"
   end
end

task build: ["MergeAccelerator.class", "table.yaml", :create]

file "table.yaml" => "match_weights.csv" do |t|
   sh "ruby ./convert_csv_to_yaml.rb #{t.prerequisites[0]}"
end
CLEAN << "table.yaml"

task loadDB: [:loadProviders, :loadSpecialties]

desc "Load the raw Providers into the database"
task :loadProviders => :create do
   begin
      sh "node #{BIN}/insert-providers.js Providers.tsv"
   rescue
      puts "It appears Providers is already loaded. Ignoring. If you really wanted to load Providers, clean it first."
   end
end

desc "Load the raw Specialties into the database"
task :loadSpecialties => :create do
   begin
      sh "node #{BIN}/insert-specialties.js Specialties.tsv"
   rescue
      puts "It appears Specialties is already loaded. Ignoring. If you really wanted to load Specialties, clean it first."
   end
end

desc "Run tests"
task test: [:rspec, :cucumber]

task :cucumber => [:test_create, :build] do
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

task :clean_merge do
   mysql in: "DB-truncate-merge.sql"
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

desc "Runs the :test task with code coverage enabled"
task :coverage do
   in_separate_environment do
      ENV['COVERAGE'] = "true"
      Rake::Task[:test].invoke
   end
end

file "MergeAccelerator.class" => "MergeAccelerator.java" do |t|
   sh "javac -extdirs /usr/share/java #{t.prerequisites[0]}"
end
CLEAN << "MergeAccelerator.class"

##
# Sets up the environment variables to run a test. Restores them afterward, keeping the test settings from polluting the rest of the Rakefile
def with_test_env
   in_separate_environment do
      # Overwrite environment variables with values for testing
      Dotenv.overload '.env.test'
      yield
   end
end

def with_jruby
   in_separate_environment do
      ENV['RBENV_VERSION'] = 'jruby-9.0.0.0.pre2'
      yield
   end
end

def mysql *arg
   client = SQLClient.new
   puts (client.command + arg).join(' ')
   client.run *arg
end
