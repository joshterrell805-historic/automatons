Rule = Struct.new :field, :regex, :name, :block
class Rule
   def run data
      self[:block].call data
   end
end

class Realm
   attr_reader :rules

   def initialize
      @rules = {}
   end

   def rule field, *args, &block
      @rules[field] ||= []
      @rules[field] << Rule.new(field, *args, block)
   end
end

class Cleanser
   def initialize
      @realm = Realm.new
   end

   ## Returns a list of names of defined rules
   def dump_rules
      @realm.rules.flat_map do |field, rule_list|
         rule_list.map do |rule|
            rule.name
         end
      end
   end

   def add &block
      @realm.instance_exec &block
   end

   def cleanse data
      data.each_key do |field|
         rules = @realm.rules[field]
         if rules
            rules.each do |rule|
               match = rule.regex.match data[field]
               if match
                  data[field] = rule.run(match)
               end
            end
         end
      end
   end
end
