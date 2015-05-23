require "rule.rb"
require "each_rule.rb"
class Realm
   attr_reader :rules

   def initialize
      @rules = []
   end

   def rule *args, &block
      @rules << Rules::Rule.new(*args, block)
   end

   # run a rule against each field that matches regex
   def each *args, &block
      @rules << Rules::Each.new(*args, block)
   end
end

class Cleanser
   attr_accessor :record_id
   attr_reader :missing

   def initialize
      @realm = Realm.new
      @missing = {}
   end

   def reset_missing
      @missing = {}
   end

   ## Returns a list of names of defined rules
   def dump_rules
      @realm.rules.map do |rule|
         rule.name
      end
   end

   ## This method allows rules to be defined with the 
   #  rule :field, "name"
   def add &block
      @realm.instance_exec &block
   end

   def cleanse data
      @realm.rules.each do |rule|
         result = rule.run data
         if rule.is_a? Rules::Rule and not result
            @missing[rule.field] = data[@record_id]
         end
      end
      data
   end

   def run_rule name, data
      rule = @realm.rules.find {|r| r.name == name}
      rule.run data
   end
end
