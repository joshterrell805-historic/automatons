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
            if parts[0].nil?
               "%s (%s) %s-%s" % parts[1..4]
            else
               "%s %s (%s) %s-%s" % parts
            end
         end

         def format_country_code_phone parts
            "%s (%s) %s-%s" % parts
         end

         each /^\s*(.*?)\s*$/, "strip whitespace" do |match|
            match[1]
         end

         rule :phone, /^(\d{3})\D(\d{3})\D(\d{4})$/, "separated phone" do |match|
            format_phone match[1..3]
         end 

         rule :phone, /^(\d{3})(\d{3})(\d{4})$/, "all number phone" do |match|
            format_phone match[1..3]
         end

         rule :phone, /^(011)?(\d{1,2})(\d{3})(\d{3})(\d{4})$/, "international phone" do |match|
            format_international_phone match[1..5]
         end

         rule :phone, /^(\d{2})(\d{3})(\d{3})(\d{4})$/, "country code" do |match|
            format_country_code_phone match[1..4]
         end
      end
   end
end
