Feature: Merging
   In order to get a grade, we need to merge records.

   Background:
      Given the standard business rules
      And an empty database


   Scenario: Merge identical records
      Given 2 standard individual source records in SProvider
      When I run a clean
      When I run a merge
      Then the "Merge" table should contain:
      """
      mId: 1
      sId: 24614
      """
      And the "Merge" table should contain:
      """
      mId: 1
      sId: 24615
      """
      And the "MProvider" table should contain:
      """
      id: 1
      type: Individual
      name: Christina L Grant
      """
      And the "MIndividual" table should contain:
      """
      id: 1
      gender: f
      dateOfBirth: '01-01-2000'
      isSoleProprietor: n
      """
      And the "MProvider_PhoneNumber" table should contain:
      """
      mId: 1
      phone: 1
      """
      And the "MProvider_SecondarySpecialty" table should contain:
      """
      mId: 1
      specialty: 1
      """
      And the "MProvider_PrimarySpecialty" table should contain:
      """
      mId: 1
      specialty: 1
      """
      And the "MProvider_MailingAddress" table should contain:
      """
      mId: 1
      address: 1
      """
      And the "MProvider_PracticeAddress" table should contain:
      """
      mId: 1
      address: 1
      """
      And the "Audit" table should contain:
      """
      sId: 24614
      mId: 1
      action: "merge duplicate records"
      """
