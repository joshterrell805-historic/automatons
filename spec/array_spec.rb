require 'array'
describe Array do
   describe "#split" do
      before :each do
         @a = (1..100).to_a
      end
      it "yields groups of n records" do
         count = 0
         @a.split 10 do |group|
            expect(group.length).to eq(10)
            count += 1
         end
         expect(count).to eq(10)
      end

      it "never yields the same record twice" do
         seen = {}
         @a.split 15 do |group|
            group.each do |record|
               expect(seen).to_not include(record)
               seen[record] = true
            end
         end
      end
   end
end
