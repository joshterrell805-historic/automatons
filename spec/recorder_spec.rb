require 'spec_helper'
require 'recorder'
require 'rule'

describe Recorder do
   ID = :id
   RID = 1
   before :each do
      @recorder = Recorder.new
      @recorder.id = ID
      @rule = Rules::Rule.new :this, nil, "test", nil
      @data = {ID => RID, :this => "abc"}
   end

   describe "#add" do
      it "stores the result of running a rule on some data" do
         @recorder.add @rule, @data, true
         expect(@recorder.dirty).to eq({})
         expect(@recorder.cleansed).to eq({:this => [RID]})
      end

      it "calls #field on the rule to determine the field" do
         rule = double("rule")
         expect(rule).to receive(:field)
         @recorder.add rule, @data, true
      end
   end

   describe "#cleansed" do
      it "returns a hash of fields and lists of records with that field cleansed" do
         @recorder.add @rule, @data, true
         expect(@recorder.cleansed).to be_a(Hash)
         expect(@recorder.cleansed[:this]).to include(RID)
      end

      it "only returns one instance of a record in each field list" do
         @recorder.add @rule, @data, true
         @recorder.add @rule, @data, true
         expect(@recorder.cleansed).to eq({:this => [RID]})
      end

      it "will return a record if it ever was cleansed" do
         @recorder.add @rule, @data, false
         @recorder.add @rule, @data, true
         @recorder.add @rule, @data, false
         expect(@recorder.cleansed).to eq({:this => [RID]})
      end
   end

   describe "#dirty" do
      it "returns a hash of fields and lists of records with that field unmatched by all rules" do
         @recorder.add @rule, @data, false
         expect(@recorder.dirty).to be_a(Hash)
         expect(@recorder.dirty[:this]).to contain_exactly(RID)
      end

      it "only returns one instance of a record in each field list" do
         @recorder.add @rule, @data, false
         @recorder.add @rule, @data, false
         expect(@recorder.dirty[:this]).to contain_exactly(RID)
      end

      it "will not return a record if it ever was cleansed" do
         @recorder.add @rule, @data, false
         @recorder.add @rule, @data, true
         @recorder.add @rule, @data, false
         expect(@recorder.dirty[:this]).to_not include(RID)
      end
   end
end

