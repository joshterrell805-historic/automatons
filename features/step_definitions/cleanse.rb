require './spec/example.rb'
require 'database'
require 'cleanser'
require 'app'
require 'business_rules.rb'

Before do
   @cleanser = Cleanser.new
   @data = {}
end

Given /^the standard business rules$/ do
   @cleanser = BusinessRules.new.cleanser
end

Given /^an empty database$/ do
   @db = Database.new "automatons_test"
   @db.source "DB-cleanup.sql"
   @db.source "DB-setup.sql"
end

Given /^this cleanse rule:$/ do |string|
   @cleanser.add do
      eval string
   end
end

Given /^data with "(.*?)" set to "(.*?)"$/ do |arg1, arg2|
   @data[arg1.to_sym] = arg2
end

Given /^"(.*?)" with value "(.*?)"$/ do |field, value|
   @data = {field.to_sym => value}
end

Given /^a standard record in SProvider$/ do
   record = Example.get_standard_record
   table = @db[:SProvider]
   table.insert record
end

When /^I clean it$/ do
   a = App.new
   a.db = @db
   a.cleanser = @cleanser
   a.cleanse
end

When /^I run "(.*?)"$/ do |rule_name|
   @cleansed = @cleanser.run_rule rule_name, @data
end

When /^I run the cleanse$/ do
   @cleansed = @cleanser.cleanse @data
end

Then /^"(.*?)" should be "(.*?)"$/ do |arg1, arg2|
   expect(@cleansed[arg1.to_sym]).to eq(arg2)
end
