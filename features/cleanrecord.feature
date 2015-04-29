Feature: Clean a record
   As a customer,
   I want the data in my records to be in a consistent format.
   So I can query it more easily
   And so I can write rules to merge records more easily

   Scenario: Clean record should be unchanged
      Given the following record:
      """
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
      PRIMARY_PHONE: '(555) 555-5555 [x5565]'
      PRIMARY_SPECIALTY: 390200000X
      SECONDARY_SPECIALTY: 390200000X
      """
      When I clean it
      Then I should have this record:
      """
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
      PRIMARY_PHONE: '(555) 555-5555 [x5565]'
      PRIMARY_SPECIALTY: 390200000X
      SECONDARY_SPECIALTY: 390200000X
      """

   Scenario: Dirty phone number
      Given a standard record with:
      """
      PRIMARY_PHONE: '555-555-5555'
      """
      When I clean it
      Then I should have the same record with:
      """
      PRIMARY_PHONE: '(555) 555-5555'
      """
   Scenario: Dirty DOB
   Scenario: Dirty sole proprietor
