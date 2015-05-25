Feature: Cleaning
   In order to make it easier to match against the data in the database, we
   need to cleanse it and break it into separate fields according to the
   standard schema.

   Background:
      Given the standard business rules
      And an empty database

   Scenario: Clean record should be unchanged
      Given a standard individual source record in SProvider
      When I run a clean
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
      And the "Specialty" table should contain:
      """
      code: 390200000X
      """
      And the "CProvider" table should contain:
      """
      id: 24614
      type: Individual
      name: Christina L Grant
      primarySpecialty: 1
      secondarySpecialty: 1
      mailingAddress: 1
      practiceAddress: 1
      phone: 1
      """
      And the "CIndividual" table should contain:
      """
      gender: F
      dateOfBirth: '01-01-2000'
      isSoleProprietor: N
      id: 24614
      """

   Scenario: Clean org record should be unchanged
      Given a standard organization source record in SProvider
      When I run a clean
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
      And the "Specialty" table should contain:
      """
      code: 390200000X
      """
      And the "CProvider" table should contain:
      """
      id: 24614
      type: Organization
      name: Christina L Grant
      primarySpecialty: 1
      secondarySpecialty: 1
      mailingAddress: 1
      practiceAddress: 1
      phone: 1
      """
      And the "COrganization" table should contain:
      """
      id: 24614
      """

   Scenario: Dirty record should be cleansed
      Given a standard individual source record in SProvider
      When I run a clean
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
      And the "Specialty" table should contain:
      """
      code: 390200000X
      """
      And the "CProvider" table should contain:
      """
      id: 24614
      type: Individual
      name: Christina L Grant
      primarySpecialty: 0
      secondarySpecialty: 0
      mailingAddress: 1
      practiceAddress: 1
      phone: 1
      """
      And the "CIndividual" table should contain:
      """
      gender: F
      dateOfBirth: '01-01-2000'
      isSoleProprietor: N
      id: 24614
      """
