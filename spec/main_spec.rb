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
            table = double("table")
            expect(@db).to receive(:[]).and_return table
            expect(table).to receive(:where).with(abc: "def").and_return(table)
            expect(table).to receive(:where).with(def: "thing").and_return(table)
            expect(table).to receive(:count).and_return 1

            @main.check_insert(:table, {abc: "def", def: "thing"})
         end

         it "does not insert if the record exists" do
            table = double("table")
            allow(@db).to receive(:[]).and_return table
            expect(table).to receive(:where).with(abc: "def").and_return(table)
            expect(table).to receive(:where).with(def: "thing").and_return(table)
            expect(table).to receive(:count).and_return 1
            expect(table).to_not receive(:insert)

            @main.check_insert(:table, {abc: "def", def: "thing"})
         end
      end

      describe "::filter_data" do
         before(:all) do
            @source = {abc: 'def', hjk: 'rws', lly: 'thing', kki: 'tii'}
         end

         it "returns a hash with a subset of data" do
            dest = {abc: :iit}

            result = Main.filter_data @source, dest
            expect(result).to eq({iit: 'def'})
         end

         it "accepts an array of keys to transfer directly" do
            dest = [:abc]

            result = Main.filter_data @source, dest
            expect(result).to eq({abc: 'def'})
         end

         it "accepts two arrays, one of source and one of destination keys" do
            source = [:abc]
            dest = [:iit]

            result = Main.filter_data @source, source, dest
            expect(result).to eq({iit: 'def'})
         end

         it "accepts two arrays and a hash of mappings" do
            source = [:abc]
            dest = [:iit]
            hash = {lly: :ping}

            result = Main.filter_data @source, source, dest, hash
            expect(result).to eq({iit: 'def', ping: 'thing'})
         end

         it "ignores order except for Array pairs" do
            source = [:abc]
            dest = [:iit]
            hash = {lly: :ping}

            result = Main.filter_data @source, source, dest, hash
            expect(result).to eq({iit: 'def', ping: 'thing'})

            result = Main.filter_data @source, source, dest, hash
            expect(result).to eq({iit: 'def', ping: 'thing'})

            result = Main.filter_data @source, hash, source, dest
            expect(result).to eq({iit: 'def', ping: 'thing'})

            result = Main.filter_data @source, hash, source
            expect(result).to eq({abc: 'def', ping: 'thing'})

            result = Main.filter_data @source, source, hash
            expect(result).to eq({abc: 'def', ping: 'thing'})
         end
      end
   end
end
