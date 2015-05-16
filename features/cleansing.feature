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
      street: 225 E Chicago Ave
      unit: ''
      city: Chicago
      region: IL
      postCode: '60611'
      county: Cook
      country: USA
      """
      And the "Address" table should contain:
      """
      street: 225 E Chicago Ave
      unit: ''
      city: Chicago
      region: IL
      postCode: '60611'
      county: Cook
      country: USA
      """
      And the "CProvider" table should contain:
      """
      id: 24614
      type: Individual
      name: Christina L Grant
      """
      And the "CIndividual" table should contain:
      """
      gender: F
      dateOfBirth: '01-01-2000'
      isSoleProprietor: N
      """
