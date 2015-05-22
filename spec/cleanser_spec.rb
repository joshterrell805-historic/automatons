require 'cleanser'

describe Cleanser do
   before :each do
      @cleanser = Cleanser.new
   end

   describe "#run_rule" do
      context "single rule" do
         before :each do
            @cleanser.add do
               rule :thing, /^abc/, "first" do
                  "changed"
               end

               rule :thing, //, "second" do
                  "wrong"
               end
            end
         end

         it "runs a named rule" do
            expect(@cleanser.run_rule "first", {:thing => "abc"}).to eq({:thing => "changed"})
         end

         it "respects the rule matcher" do
            expect(@cleanser.run_rule "first", {:thing => "gef"}).to eq({:thing => "gef"})
            expect(@cleanser.run_rule "first", {:thing => "abcdef"}).to eq({:thing => "changed"})
         end
      end

      context "each rule" do
         it "runs a named rule" do
            @cleanser.add do
               rule :field, /f/, "burrito" do
                  "not rawr"
               end
               each /s$/, "taco" do
                  "rawr"
               end
            end
            expect(@cleanser.run_rule "taco",
                   {:a => "s", :b => "q", :c => "is"})
            .to eq({:a => "rawr", :b => "q", :c => "rawr"})
         end
      end
   end

   describe "#dump_rules" do
      it "returns an empty list if there are no rules" do
         expect(@cleanser.dump_rules).to eq([])
      end
      it "returns a list of defined rules' names" do
         @cleanser.add do
            rule :field, /test/, "test this" do
               "abc"
            end
            each nil, "run on everything!" do
               "adf"
            end
         end
         expect(@cleanser.dump_rules).to eq(["test this", "run on everything!"])
      end
   end

   describe "#cleanse" do
      it "(each) cleans a field" do
         @cleanser.add do
            each /test/, "test this" do
               "abc"
            end
         end
         expect(@cleanser.cleanse({:f => "test", :g => "tests", :h => "blah"}))
         .to eq({:f=> "abc", :g => "abc", :h => "blah"})
      end
      it "cleans a field" do
         @cleanser.add do
            rule :field, /test/, "test this" do
               "abc"
            end
         end
         expect(@cleanser.cleanse({:field => 'test'})).to eq({:field => "abc"})
      end
      it "checks the field contents" do
         @cleanser.add do
            rule :field, /test/, "test this" do |string, match|
               "abc"
            end
         end
         expect(@cleanser.cleanse({:field => 'taco'})).to eq({:field => "taco"})
      end
      it "passes the MatchData to the block" do
         @cleanser.add do
            rule :phone, /(\d{3})-(\d{3})-(\d{4})/, "change pty to ppp" do |match|
               "(%s) %s-%s" % match[1..3].to_a
            end
         end
         expect(@cleanser.cleanse({:phone => '805-555-5555'})).to eq({:phone => "(805) 555-5555"})
      end

      it "leaves other fields untarnished" do
         @cleanser.add do
            rule :phone, //, "changes phone numbers" do |match|
               "555-555-5555"
            end
         end
         expect(@cleanser.cleanse({:name => "tony", :phone => '805-555-5555'})).to eq({:name => "tony", :phone => "555-555-5555"})
      end
   end

   describe "#add" do
      it "adds a rule to the cleanser" do
         @cleanser.add do
            rule :test, nil, "add rule" do |rule|
               "thing"
            end
         end

         expect(@cleanser.dump_rules).to include("add rule")
      end
   end
end
