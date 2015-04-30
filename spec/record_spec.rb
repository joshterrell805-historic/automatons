require 'spec_helper'
require 'example'

module MDM
   describe Record do
      before :each do
         @record = Example.get_standard_record
      end

      describe "#clean" do
         it "converts ###-###-#### phone numbers to (###) ###-####" do
            @record.phone = "555-555-5555"
            @record.clean
            expect(@record.phone).to eq("(555) 555-5555")
         end
         it "makes no change to (###) ###-#### [x####] numbers" do
            @record.phone = "(555) 555-5555 [x1234]"
            @record.clean
            expect(@record.phone).to eq("(555) 555-5555 [x1234]")
         end
      end

      describe "#initialize" do
         it "parses record" do
            record = Record.new(Example::STANDARD_RECORD)
            expect(record.id).to eq('24614')
            expect(record.type).to eq('Individual')
            expect(record.name).to eq('Christina L Grant')
            expect(record.gender).to eq('F')
            expect(record.dob).to eq('01-01-2000')
            expect(record.sole_proprietor).to eq('N')
            expect(record.phone).to eq('(555) 555-5555')
            expect(record.primary_specialty).to eq('390200000X')
            expect(record.secondary_specialty).to eq('390200000Y')
         end
      end

      describe "#update" do
         it "parses YAML and updates the document" do
            @record.update 'ID: "111111"'
            expect(@record.id).to eq('111111')
         end
      end

      describe "#==" do
         it "does normal equality" do
            expect(@record == nil).to be false
            expect(@record == Class).to be false
            expect(@record == Record.new('{}')).to be false
            expect(@record == Example.get_standard_record).to be true
         end
      end
   end
end
