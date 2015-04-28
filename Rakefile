require 'rake/clean'

task default: [:loadDB]

task loadDB: "Providers-clean.tsv" do
   sh "echo NODE!"
end
CLEAN << "Providers-clean.tsv"

file "Providers-clean.tsv" => "Providers.tsv" do |t|
   sh "ruby transform.rb Providers.tsv > #{t.name}"
end
