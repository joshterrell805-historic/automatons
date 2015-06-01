require 'merger'
describe Merger do
   before :each do
      @db = instance_double("Database")
      @first = Example.get_clean_standard_record
      second = Example.get_clean_standard_record
      second[:id] += 1
      @second = second
      @source = [@first, @second]
      @merger = Merger.new @db
   end

   describe "#score_records" do
      it "compares two records" do
         ret = @merger.score_records @first, @first
         expect(ret).to eq(1)
      end

      it "compares all fields by default" do
         ret = @merger.score_records @first, @first
         expect(ret).to eq(1)
      end

      it "returns a smaller value if records don't match" do
         @first[:name] = "tom sawyer"
         @merger.config = [{'fields' => ['name'], 'weight' => 1},
                           {'fields' => ['gender'], 'weight' => 10}]
         ret = @merger.score_records @first, @second
         expect(ret).to eq(10/11.to_r)
      end
   end

   describe "#merge_records" do
      it "merges two records" do
         @db.as_null_object

         first = nil
         expect(@db).to receive(:insert_merge).twice do |arg|
            if first
               expect(arg[:mId]).to eq(first[:mId])
            else
               first = arg
            end
         end

         @merger.merge_records @first, @second
      end

      it "inserts the results into the database" do
         check_tables
         @merger.merge_records @first, @second
      end
   end

   describe "#match_record" do
      it "returns the best match above a threshold with available records" do
         expect(@merger.match_record @first, @source[1..-1]).to eq(@second)
      end
   end

   def check_tables
      expect(@db).to receive(:insert_mprovider).once
      expect(@db).to receive(:insert_mindividual).once
      expect(@db).to receive(:insert_merge).twice
      expect(@db).to receive(:insert_provider_x_phone).at_least(:once)
      expect(@db).to receive(:insert_provider_x_secondary_specialty).at_least(:once)
      expect(@db).to receive(:insert_provider_x_primary_specialty).at_least(:once)
      expect(@db).to receive(:insert_provider_x_mailing_address).at_least(:once)
      expect(@db).to receive(:insert_provider_x_practice_address).at_least(:once)
      expect(@db).to receive(:insert_audit).twice
   end
end
