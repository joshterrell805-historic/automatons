require 'business_rules.rb'

Given /^the standard business rules$/ do
   @cleanser = BusinessRules.new.cleanser
end

Given(/^"(.*?)" with value "(.*?)"$/) do |field, value|
   @data = {field.to_sym => value}
end

When(/^I run "(.*?)"$/) do |rule_name|
   @cleansed = @cleanser.run_rule rule_name, @data
end

