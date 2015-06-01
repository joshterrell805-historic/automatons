When(/^I run a merge$/) do
   @merger = Merger.new @db
   a = Main.new @db, @cleanser, @merger
   a.merge
end
