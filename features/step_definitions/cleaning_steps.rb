require 'record.rb'
require './spec/example.rb'


Given /^the following record:$/ do |string|
   @record = MDM::Record.new string
end

Given /^a standard record with:$/ do |string|
   @record = get_standard_record
   @record.update string
end

When /^I clean it$/ do
   @record.clean
end

Then /^I should have this record:$/ do |string|
   record = MDM::Record.new string
   expect(@record).to eq(record)
end

Then /^I should have the same record with:$/ do |string|
   record = get_standard_record
   record.update string
   expect(@record).to eq(record)
end
