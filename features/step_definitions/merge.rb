When(/^I run a merge(?: with threshold (\d+(?:.\d+)?))?$/) do |threshold|
   if threshold
      threshold = threshold.to_f
   else
      threshold = 0.9
   end
   @merger = Merger.new @db
   @merger.config = [{'fields' => 'all', 'weight' => 10}]
   @merger.threshold = threshold
   a = Main.new @db, @cleanser, @merger
   a.merge
end
