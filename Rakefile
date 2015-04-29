require 'rake/clean'

BIN = File.absolute_path './bin'
ENV["PATH"] += BIN

ENV["mysql_host"] = "joshterrell.com"
ENV["mysql_password"] = "z8eEnVt*"
ENV["mysql_user"] = "automatons"
ENV["mysql_database"] = "automatons"

task default: [:loadDB]

desc "Load the cleaned Providers file into the database"
task loadDB: "Providers-clean.tsv" do
   sh "node insert-providers.js Providers-clean.tsv"
end
CLEAN << "Providers-clean.tsv"

desc "Create a cleaned version of the Providers file with no duplicate ids"
file "Providers-clean.tsv" => "Providers.tsv" do |t|
   sh "ruby #{BIN}/transform.rb Providers.tsv > #{t.name}"
end
