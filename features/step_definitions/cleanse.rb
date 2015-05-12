require 'cleanser'

Before do
   @cleanser = Cleanser.new
   @data = {}
end

Given(/^this cleanse rule:$/) do |string|
   @cleanser.add do
      eval string
   end
end

Given(/^data with "(.*?)" set to "(.*?)"$/) do |arg1, arg2|
   @data[arg1.to_sym] = arg2
end

When(/^I run the cleanse$/) do
   @cleansed = @cleanser.cleanse @data
end

Then(/^"(.*?)" should be "(.*?)"$/) do |arg1, arg2|
   expect(@cleansed[arg1]).to eq(arg2)
end
