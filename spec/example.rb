require 'psych'
# This module provides an easy way to get a record like the ones from the
# database
module Example
   STANDARD_RECORD = <<END
id: '24614'
type: Individual
name: Christina L Grant
gender: F
DateOfBirth: '01-01-2000'
isSoleProprietor: N
mStreet: 225 E Chicago Ave
mUnit: ''
mCity: Chicago
mRegion: IL
mPostCode: '60611'
mCounty: Cook
mCountry: USA
pStreet: 225 E Chicago Ave
pUnit: ''
pCity: Chicago
pRegion: IL
pPostCode: '60611'
pCounty: Cook
pCountry: USA
phone: '(555) 555-5555 [x5565]'
primarySpecialty: 390200000X
secondarySpecialty: 390200000X
END

   def Example.get_standard_record
      # Parse the YAML hash above into a Ruby hash. Easier than trying to clone
      # independent copies of the data to avoid things touching each other's
      # data
      Psych.parse(STANDARD_RECORD).to_ruby
   end
end
