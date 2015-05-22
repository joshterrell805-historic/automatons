require 'cleanser'
class BusinessRules
   attr_accessor :cleanser
   def initialize
      @cleanser = Cleanser.new
      add_rules
   end

   private

   def add_rules
      add_phone_rules
   end

   def add_phone_rules
      @cleanser.add do
         def format_phone parts
            "(%s) %s-%s" % parts
         end

         def format_international_phone parts
            "%s %s (%s) %s-%s" % parts
         end

         rule :phone, /(\d{3})\.(\d{3})\.(\d{4})/, "dotted phone" do |match|
            format_phone match[1..3]
         end

         rule :phone, /(\d{3})-(\d{3})-(\d{4})/, "dashed phone" do |match|
            format_phone match[1..3]
         end

         rule :phone, /(\d{3})(\d{3})(\d{4})/, "all number phone" do |match|
            format_phone match[1..3]
         end

         rule :phone, /(011)(\d{2})(\d{3})(\d{3})(\d{4})/, "international phone" do |match|
            format_international_phone match[1..5]
         end

         each /^\s*(.*?)\s*$/, "strip whitespace" do |match|
            match[1]
         end
      end
   end
end
