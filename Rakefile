require 'rake/clean'

BIN = File.absolute_path './bin'
ENV["PATH"] += BIN

ENV["mysql_host"] = "joshterrell.com"
ENV["mysql_password"] = "z8eEnVt*"
ENV["mysql_user"] = "automatons"
ENV["mysql_database"] = "automatons"

task default: [:loadDB]
task loadDB: [:loadProviders, :loadSpecialties]

desc "Load the raw Providers into the database"
task loadProviders: "Providers-clean.tsv" do
   sh "node #{BIN}/insert-providers.js Providers-clean.tsv"
end
desc "Load the raw Specialties into the database"
task :loadSpecialties do
   sh "node #{BIN}/insert-specialties.js Specialties.tsv"
end
CLEAN << "Providers-clean.tsv"

desc "Create a cleaned version of the Providers file with no duplicate ids"
file "Providers-clean.tsv" => "Providers.tsv" do |t|
   sh "ruby #{BIN}/transform.rb Providers.tsv > #{t.name}"
end

desc "Run tests"
task test: [:rspec, :cucumber]

task :cucumber do
   sh "cucumber"
end

task :rspec do
   sh "rspec"
end
