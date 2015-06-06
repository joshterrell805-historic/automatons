Feature: Merge auditing
   To get a grade
   I need to be able to find out which rules caused a merge

   Background:
      Given an empty database
      And 2 standard individual source records in SProvider
      And I run a clean

   Scenario: Basic rule use
      Given the merge rules:
      """
      - fields: all
        weight: 1
      """
      When I run a merge
      Then the "Audit" table should contain:
      """
      score: 17
      rule: "all => 1"
      sId: 24614
      mId: 1
      """
