require 'rule'

describe Rule do
   before :each do
      @rule = Rule.new :thing, /b/, "a name", Proc.new {"output"}
   end

   describe "#run" do
      it "runs the rule on the correct field" do
         result = @rule.run thing: "beet", frog: "beet"
         expect(result[:thing]).to eq("output")
         expect(result[:frog]).to eq("beet")
      end
      it "matches the regex against the input data" do
         result = @rule.run thing: "beet"
         expect(result[:thing]).to eq("output")
         result = @rule.run thing: "cat"
         expect(result[:thing]).to eq("cat")
      end
      it "won't run on a missing field" do
         ran = false
         rule = Rule.new :thing, /^/, "a name", Proc.new {ran=true}
         result = rule.run frog: "beet"
         expect(ran).to be false
      end
      it "runs on a present field" do
         ran = false
         rule = Rule.new :thing, /^/, "a name", Proc.new {ran=true}
         result = rule.run thing: "cat"
         expect(ran).to be true
      end
      it "treats a nil regex as always matching" do
         rule = Rule.new :thing, nil, "run", Proc.new {"ran"}
         result = rule.run thing: "goat"
         expect(result[:thing]).to eq("ran")
      end
   end
end
