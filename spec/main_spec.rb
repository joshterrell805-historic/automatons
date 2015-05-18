require 'main'
require 'example'
describe Main do
   before(:each) do
      @db = double("db")
      @cleanser = double("cleanser")
      @main = Main.new @db, @cleanser
   end
   describe "#cleanse" do
      xit "runs the cleanser on each record" do
         allow(@db).to receive(:[])
         allow(@db).to receive(:[]).with(:SProvider).and_return([{},{}])
         expect(@cleanser).to receive(:cleanse).with({}).exactly(2).times
         @main.cleanse
      end
      xit "splits the data into the proper columns" do

      end

      describe "#check_insert" do
         it "checks for duplicate records in the db" do
            key_field = :abc
            table = double("table")
            allow(@db).to receive(:[]).and_return table
            allow(table).to receive(:where).and_return(table)
            expect(table).to receive(:get).with(key_field).and_return nil
            expect(table).to receive(:insert)

            @main.check_insert(:table, key_field, {key_field => "def", other: "thing"})
         end

         it "does not insert if the record exists" do
            key_field = :abc
            key_value = "def"

            table = double("table")
            allow(@db).to receive(:[]).and_return table
            allow(table).to receive(:where).and_return(table)
            expect(table).to receive(:get).with(key_field).and_return key_value
            expect(table).to_not receive(:insert)

            @main.check_insert(:table, key_field, {key_field => key_value, other: "thing"})
         end
      end
   end
end
