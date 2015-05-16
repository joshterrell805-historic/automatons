Feature: Cleaning
   In order to make it easier to match against the data in the database, we
   need to cleanse it and break it into separate fields according to the
   standard schema.

   Background:
      Given the standard business rules
      And an empty database

   Scenario: Clean record should be unchanged
      Given a standard record in SProvider
      When I clean it
      Then the "PhoneNumber" table should contain:
      """
      phone: '(555) 555-5555 [x5565]'
      """
      And the "Address" table should contain:
      """
      mStreet: 225 E Chicago Ave
      mUnit: ''
      mCity: Chicago
      mRegion: IL
      mPostCode: '60611'
      mCounty: Cook
      mCountry: USA
      """
      And the "Address" table should contain:
      """
      pStreet: 225 E Chicago Ave
      pUnit: ''
      pCity: Chicago
      pRegion: IL
      pPostCode: '60611'
      pCounty: Cook
      pCountry: USA
      """
      And the "CProvider" table should contain:
      """
      id: '24614'
      type: Individual
      name: Christina L Grant
      """
      And the "CIndividual" table should contain:
      """
      gender: F
      DateOfBirth: '01-01-2000'
      isSoleProprietor: N
      """
