require 'spec_helper'
require 'main'
require 'example'
describe Main do
   before(:each) do
      @db = instance_double("Database")
      @cleanser = instance_double("Cleanser")
      @merger = instance_double("Merger")

      @main = Main.new @db, @cleanser, @merger
   end
   context "cleansing" do
      let(:record1) {{:type => 'individual', :phone => '555-555-5555'}}
      let(:record2) {{:type => 'organization', :phone => '555-555-5555'}}

      describe "#cleanse" do
         it "runs the cleanser on each record" do
            source_data = [record1, record2]

            @db.as_null_object
            allow(@db).to receive(:source_records).and_return(source_data)
            allow(@cleanser).to receive(:missing).and_return({})

            expect(@cleanser).to receive(:cleanse).with(record1).once
            expect(@cleanser).to receive(:cleanse).with(record2).once

            @main.cleanse
         end

         it "only inserts a phone number if one exists on a record" do
            pending "Refactoring from 'runs the cleanser' case"
            fail
         end
      end

      describe "#insert_phone" do
         xit "inserts a phone number if one exists on a record" do
            record1 = {:type => 'individual', :phone => '555-555-5555'}
            record2 = {:type => 'organization', :phone => nil}
            source_data = [record1, record2]

            db = instance_spy("Database")
            allow(db).to receive(:source_records).and_return(source_data)
            allow(@cleanser).to receive(:cleanse)

            main = Main.new db, @cleanser

            expect(@db).to receive(:insert_phone).once
            @main.cleanse
         end
      end
   end

   context "merging" do
      before :each do
         @first = Example.get_clean_standard_record
         second = Example.get_clean_standard_record
         second[:id] += 1
         @second = second
         @source = [@first, @second]
      end
      describe "#merge" do
         it "merges identical pairs of records" do
            table_indiv = double("Dataset")
            table_org = double("Dataset")
            allow(@db).to receive(:cindividual_records).and_return(table_indiv)
            allow(@db).to receive(:corganization_records).and_return(table_org)
            allow(table_indiv).to receive(:all).and_return(@source)
            allow(table_org).to receive(:all).and_return([])

            expect(@merger).to receive(:match_record_list).with(@source).and_return(@source.length)
            expect(@merger).to receive(:match_record_list).with([]).and_return(0)
            @main.merge
         end

         it "logs the rules that contributed to the match" do
            pending
            fail
         end
      end
   end
end
