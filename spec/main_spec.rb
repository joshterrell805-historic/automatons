require 'spec_helper'
require 'main'
require 'example'
describe Main do
   before(:each) do
      @db = instance_double("Database")
      @cleanser = instance_double("Cleanser")

      @main = Main.new @db, @cleanser
   end
   describe "#cleanse" do
      it "runs the cleanser on each record" do
         number_of_records = 2

         record1 = {:type => 'individual', :phone => '555-555-5555'}
         record2 = {:type => 'organization', :phone => '555-555-5555'}
         source_data = [record1, record2]

         expect(@db).to receive(:source_records).and_return(source_data)
         expect(@cleanser).to receive(:cleanse).with(record1).once
         expect(@cleanser).to receive(:cleanse).with(record2).once
         expect(@db).to receive(:insert_address).exactly(number_of_records * 2).times
         expect(@db).to receive(:insert_specialty).exactly(number_of_records * 2).times

         expect(@db).to receive(:insert_phone).exactly(number_of_records).times
         expect(@db).to receive(:insert_cprovider).exactly(number_of_records).times

         expect(@db).to receive(:insert_corganization).once
         expect(@db).to receive(:insert_cindividual).once

         allow(@cleanser).to receive(:missing).and_return({})

         @main.cleanse
      end
   end
end
