require 'record.rb'

module Example
   STANDARD_RECORD = <<END
ID: '24614'
TYPE: Individual
NAME: Christina L Grant
GENDER: F
DateOfBirth: '01-01-2000'
IS_SOLE_PROPRIETOR: N
MAILING_STREET: 225 E Chicago Ave
MAILING_UNIT: ''
MAILING_CITY: Chicago
MAILING_REGION: IL
MAILING_POST_CODE: '60611'
MAILING_COUNTY: Cook
MAILING_COUNTRY: USA
PRACTICE_STREET: 225 E Chicago Ave
PRACTICE_UNIT: ''
PRACTICE_CITY: Chicago
PRACTICE_REGION: IL
PRACTICE_POST_CODE: '60611'
PRACTICE_COUNTY: Cook
PRACTICE_COUNTRY: USA
PRIMARY_PHONE: '(555) 555-5555'
PRIMARY_SPECIALTY: 390200000X
SECONDARY_SPECIALTY: 390200000Y
END

   def Example.get_standard_record
      MDM::Record.new STANDARD_RECORD
   end
end
