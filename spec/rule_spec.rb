require 'spec_helper'
require 'rule'

describe Rules::Rule do
   before :each do
      @rule = Rules::Rule.new :thing, /b/, "a name", Proc.new {"output"}
   end

   describe "#run" do
      it "runs the rule on the correct field" do
         data = {thing: "beet", frog: "beet"}
         @rule.run data
         expect(data[:thing]).to eq("output")
         expect(data[:frog]).to eq("beet")
      end
      it "matches the regex against the input data" do
         data = {thing: "beet"}
         @rule.run data
         expect(data[:thing]).to eq("output")

         data = {thing: "cat"}
         @rule.run data
         expect(data[:thing]).to eq("cat")
      end
      it "won't run on a missing field" do
         ran = false
         rule = Rules::Rule.new :thing, /^/, "a name", Proc.new {ran=true}
         result = rule.run frog: "beet"
         expect(ran).to be false
      end
      it "runs on a present field" do
         ran = false
         rule = Rules::Rule.new :thing, /^/, "a name", Proc.new {ran=true}
         rule.run thing: "cat"
         expect(ran).to be true
      end
      it "treats a nil regex as always matching" do
         rule = Rules::Rule.new :thing, nil, "run", Proc.new {"ran"}
         data = {thing: "goat"}
         rule.run data
         expect(data[:thing]).to eq("ran")
      end
   end
end
