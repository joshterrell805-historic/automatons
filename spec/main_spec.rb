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
   end
end
