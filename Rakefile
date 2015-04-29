require 'rake/clean'

ENV["mysql_host"] = "joshterrell.com"
ENV["mysql_password"] = "z8eEnVt*"
ENV["mysql_user"] = "automatons"
ENV["mysql_database"] = "automatons"

task default: [:loadDB]

task loadDB: "Providers-clean.tsv" do
   sh "node insert-providers.js Providers-clean.tsv"
end
CLEAN << "Providers-clean.tsv"

file "Providers-clean.tsv" => "Providers.tsv" do |t|
   sh "ruby transform.rb Providers.tsv > #{t.name}"
end
