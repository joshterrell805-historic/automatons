Feature: Running the application
   As a user
   I expect the application to start and run
   I expect the output to reflect what the operation did

   Background:
      Given an empty database
      And 2 standard individual source records in SProvider

   Scenario: Boot and print help
      When I run `app`
      Then the output should contain "Usage:"

   Scenario: Boot and cleanse
      When I run `app --cleanse`
      Then the output should contain:
      """
      Cleansed 2 records
      """
