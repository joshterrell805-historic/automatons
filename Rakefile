require 'rake/clean'

BIN = File.absolute_path './bin'
ENV["PATH"] += BIN

ENV["mysql_host"]     = "localhost"
ENV["mysql_password"] = "z8eEnVt*"
ENV["mysql_user"]     = "automatons"
ENV["mysql_database"] = "automatons"

task default: [:loadDB]
task loadDB: [:loadProviders, :loadSpecialties]

desc "Load the raw Providers into the database"
task :loadProviders do
   sh "node #{BIN}/insert-providers.js Providers.tsv"
end

desc "Load the raw Specialties into the database"
task :loadSpecialties do
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
