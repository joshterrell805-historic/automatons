require 'example'
require 'merge-splitter'
module Splitter
   describe MergeSplitter do
      before :each do
         @db = instance_double("Database")
         @msplitter = MergeSplitter.new @db
         @first = Example.get_clean_standard_record
      end
      describe "#insert_new_merge" do
         it "inserts the data into the database" do
            expect(@db).to receive(:insert_mprovider).once
            expect(@db).to receive(:insert_mindividual).once
            expect(@db).to receive(:insert_merge).once
            expect(@db).to receive(:insert_provider_x_phone).once
            expect(@db).to receive(:insert_provider_x_secondary_specialty).once
            expect(@db).to receive(:insert_provider_x_primary_specialty).once
            expect(@db).to receive(:insert_provider_x_mailing_address).once
            expect(@db).to receive(:insert_provider_x_practice_address).once
            expect(@db).to receive(:insert_audit).once

            @msplitter.insert_new_merge :indiv, @first
         end
      end
   end
end
