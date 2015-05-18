require 'main'
describe Hash do
   describe "#filter_self" do
      before(:all) do
         @source = {abc: 'def', hjk: 'rws', lly: 'thing', kki: 'tii'}
      end

      it "returns a hash with a subset of data" do
         dest = {abc: :iit}

         result = @source.filter_self dest
         expect(result).to eq({iit: 'def'})
      end

      it "accepts an array of keys to transfer directly" do
         dest = [:abc]

         result = @source.filter_self dest
         expect(result).to eq({abc: 'def'})
      end

      it "accepts two arrays, one of source and one of destination keys" do
         source = [:abc]
         dest = [:iit]

         result = @source.filter_self source, dest
         expect(result).to eq({iit: 'def'})
      end

      it "accepts two arrays and a hash of mappings" do
         source = [:abc]
         dest = [:iit]
         hash = {lly: :ping}

         result = @source.filter_self source, dest, hash
         expect(result).to eq({iit: 'def', ping: 'thing'})
      end

      it "ignores order except for Array pairs" do
         source = [:abc]
         dest = [:iit]
         hash = {lly: :ping}

         result = @source.filter_self source, dest, hash
         expect(result).to eq({iit: 'def', ping: 'thing'})

         result = @source.filter_self source, dest, hash
         expect(result).to eq({iit: 'def', ping: 'thing'})

         result = @source.filter_self hash, source, dest
         expect(result).to eq({iit: 'def', ping: 'thing'})

         result = @source.filter_self hash, source
         expect(result).to eq({abc: 'def', ping: 'thing'})

         result = @source.filter_self source, hash
         expect(result).to eq({abc: 'def', ping: 'thing'})
      end
   end
end
