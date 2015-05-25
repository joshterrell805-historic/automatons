require 'cleanser'
require 'recorder'
require 'business_rules'

Before do
   @cleanser = Cleanser.new Recorder.new
   @data = {}
end

Given /^the standard business rules$/ do
   @cleanser = BusinessRules.new.cleanser
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
   @data[field.to_sym] = value
end

Given /^"([^"]*)" with value nil$/ do |field|
   @data[field.to_sym] = nil
end

When /^I run a clean$/ do
   a = Main.new @db, @cleanser
   a.cleanse
end

When /^I run the "(.*?)" rule$/ do |rule_name|
   @cleansed = @cleanser.run_rule rule_name, @data
end

When /^I run the cleanse$/ do
   @cleansed = @cleanser.cleanse @data
end

Then /^"(.*?)" should be "(.*?)"$/ do |arg1, arg2|
   expect(@cleansed[arg1.to_sym]).to eq(arg2)
end

Then /^"([^"]*)" should be nil$/ do |field|
   expect(@cleansed[field.to_sym]).to eq(nil)
end
