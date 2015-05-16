Feature: Running the application
   As a user
   I expect the application to start and run

   This test confirms that it does just that.

   Background:
      Given the test database configuration

   Scenario: Boot and print help
      When I run `app`
      Then the output should contain:
      """
      Usage:
      """

   Scenario: Boot and cleanse
      When I run `app --cleanse`
      Then the output should contain:
      """
      Cleansed 6 records
      """
