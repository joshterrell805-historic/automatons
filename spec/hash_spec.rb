require 'spec_helper'
require 'hash'
describe Hash do
   describe "#filter" do
      before(:all) do
         @source = {abc: 'def', hjk: 'rws', lly: 'thing', kki: 'tii'}
      end

      it "returns a new hash with a subset of data" do
         dest = {abc: :iit}

         result = @source.filter dest
         expect(result).to_not be(@source)
         expect(result).to eq({iit: 'def'})
      end

      it "accepts an array of keys to transfer directly" do
         dest = [:abc]

         result = @source.filter dest
         expect(result).to eq({abc: 'def'})
      end

      it "accepts pairs of arrays, one of source and one of destination keys" do
         source = [:abc]
         dest = [:iit]

         result = @source.filter source, dest
         expect(result).to eq({iit: 'def'})
      end

      it "accepts two arrays and a hash of mappings" do
         source = [:abc]
         dest = [:iit]
         hash = {lly: :ping}

         result = @source.filter source, dest, hash
         expect(result).to eq({iit: 'def', ping: 'thing'})
      end

      it "ignores order except for Array pairs" do
         source = [:abc]
         dest = [:iit]
         hash = {lly: :ping}

         result = @source.filter source, dest, hash
         expect(result).to eq({iit: 'def', ping: 'thing'})

         result = @source.filter source, dest, hash
         expect(result).to eq({iit: 'def', ping: 'thing'})

         result = @source.filter hash, source, dest
         expect(result).to eq({iit: 'def', ping: 'thing'})

         result = @source.filter hash, source
         expect(result).to eq({abc: 'def', ping: 'thing'})

         result = @source.filter source, hash
         expect(result).to eq({abc: 'def', ping: 'thing'})
      end
   end
end
