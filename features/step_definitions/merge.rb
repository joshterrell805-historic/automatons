When(/^I run a merge$/) do
   a = Main.new @db, @cleanser
   a.merge
end
