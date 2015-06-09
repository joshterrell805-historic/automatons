require "rule.rb"
require "each_rule.rb"
class Realm
   attr_reader :rules

   def initialize
      @rules = []
   end

   #  run a rule against a particular field which matches regex
   def rule *args, &block
      @rules << Rules::Rule.new(*args, block)
   end

   # run a rule against each field that matches regex
   def each *args, &block
      @rules << Rules::Each.new(*args, block)
   end
end

class Cleanser
   # Sets up the cleanser. The recorder allows tracking records which are
   # missed by all rules, in order to get better information about what rules
   # need to be written
   # @param recorder A Recorder to store information about rule runs on records
   def initialize recorder
      @realm = Realm.new
      @recorder = recorder
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

   def missing
      @recorder.dirty
   end

   def cleanse data
      @realm.rules.each do |rule|
         result = rule.run data

         if rule.respond_to? :field
            # Record the result of running the rule on the data
            # Allows us to track what each rule is matching
            @recorder.add rule, data, result
         end
      end

      if data[:name].count("|") != 5
         raise "data[:name] (#{data[:name]}) of record ##{data[:id]} was " +
               "not split into 6 parts"
      else
         parts = data[:name].split("|")

         data[:name_prefix] = parts[0] || ""
         data[:name_first] = parts[1] || ""
         data[:name_middle] = parts[2] || ""
         data[:name_last] = parts[3] || ""
         data[:name_suffix] = parts[4] || ""
         data[:name_credential] = parts[5] || ""

         data.delete(:name)
      end

      data
   end

   def run_rule name, data
      rule = @realm.rules.find {|r| r.name == name}
      rule.run data
   end
end
