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

   ## Returns a record which is representative of what would be found in the
   # SProviders table
   def Example.get_standard_record
      # Parse the YAML hash above into a Ruby hash. Easier than trying to clone
      # independent copies of the data to avoid things touching each other's
      # data
      Example.convert STANDARD_RECORD
   end

   ## Accepts a string of YAML and creates a hash of symbol keys to values from it.
   #Uses YAML because it's a clean way to represent large amounts of data, and it is easier than trying to create a detached Ruby object from another (we'd have to do a deep clone for safety)
   def Example.convert record
      ret = {}
      Psych.parse(record).to_ruby.each do |key, value|
         # Convert the keys to match the normal correct
         # DB return keys
         ret[key.to_sym] = value
      end
      ret
   end
end
