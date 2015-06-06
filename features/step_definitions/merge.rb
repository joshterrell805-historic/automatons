When(/^I run a merge(?: with threshold (\d+(?:.\d+)?))?$/) do |threshold|
   if threshold
      @merge_threshold = threshold.to_f
   end

   @merge_threshold ||= 0.9
   @merge_config ||= [{'fields' => 'all', 'weight' => 10}]

   m = Merger.new @db
   m.config = @merge_config
   m.threshold = @merge_threshold

   a = Main.new @db, @cleanser, m
   a.merge
end

Given /^the merge rules:$/ do |yaml|
   config = Psych.load yaml.to_s
   config.each do |rule|
      fields = rule['fields']
      if fields.is_a? Array
         rule['fields'] = fields.map {|f| f.to_sym}
      end
   end
   @merge_config = config
end
