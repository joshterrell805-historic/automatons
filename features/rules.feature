Feature: Business Rules

   Background:
      Given the standard business rules

   Scenario: 
      Given "phone" with value "555-555-5555"
      When I run "dashed phone"
      Then "phone" should be "(555) 555-5555"
