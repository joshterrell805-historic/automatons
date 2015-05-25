require 'spec_helper'
require 'each_rule'
describe Rules::Each do
   describe "#run" do
      it "runs the rule on only fields matching the regex" do
         rule = Rules::Each.new /^t/, "start with t", Proc.new {"output"}
         result = rule.run first: "taco", second: "burrito", third: "tortilla"
         expect(result[:first]).to eq("output")
         expect(result[:second]).to eq("burrito")
         expect(result[:third]).to eq("output")
      end
      it "wont execute on nil fields" do
         rule = Rules::Each.new /^t/, "start with t", Proc.new {"output"}
         result = rule.run first: nil, second: "burrito", third: "tortilla"
         expect(result[:first]).to eq(nil)
         expect(result[:second]).to eq("burrito")
         expect(result[:third]).to eq("output")
      end
      it "treats a nil regex as always matching" do
         rule = Rules::Each.new nil, "always run", Proc.new {"output"}
         result = rule.run thing: "goat", burrito: "asdf"
         expect(result[:thing]).to eq("output")
         expect(result[:burrito]).to eq("output")
      end
   end
end
