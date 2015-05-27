require 'clean-splitter'
module Splitter
   describe CleanSplitter do
      before(:each) do
         @db = instance_double("Database")
         @splitter = CleanSplitter.new @db
      end

      let(:record1) {{:type => 'individual', :phone => '555-555-5555'}}
      let(:record2) {{:type => 'organization', :phone => '555-555-5555'}}

      describe "#insert_cleansed" do
         it "splits records into the appropriate parts" do
            expect(@db).to receive(:insert_address).twice
            expect(@db).to receive(:insert_specialty).twice

            expect(@db).to receive(:insert_phone).once
            expect(@db).to receive(:insert_cprovider).once

            expect(@db).to receive(:insert_cindividual).once
            @splitter.insert_cleansed record1
         end

         it "splits organization records correctly" do
            expect(@db).to receive(:insert_address).twice
            expect(@db).to receive(:insert_specialty).twice

            expect(@db).to receive(:insert_phone).once
            expect(@db).to receive(:insert_cprovider).once

            expect(@db).to receive(:insert_corganization).once
            @splitter.insert_cleansed record2
         end
      end
   end
end
