require 'main'
require 'example'
describe Main do
   describe "#cleanse" do
      it "runs the cleanser on each record" do
         db = double("db")
         allow(db).to receive(:[])
         allow(db).to receive(:[]).with(:SProvider).and_return([{},{}])

         cleanser = double("cleanser")
         expect(cleanser).to receive(:cleanse).with({}).exactly(2).times

         main = Main.new  db, cleanser
         main.cleanse
      end
      xit "splits the data into the proper columns" do
         fakedb = []
         fakedb << Example.get_standard_record
         fakedb << Example.get_standard_record

         fake_table = double("table")

         db = double("db")
         allow(db).to receive(:[]).with(:SProvider).and_return(fakedb)
         allow(db).to receive(:[]).with(:PhoneNumber).and_return(fake_table)

         expect(fake_table).to receive(:insert)

         cleanser = double("cleanser")
         allow(cleanser).to receive(:cleanse) {|arg|  arg}

         main = Main.new db, cleanser
         main.cleanse
      end
   end
end
