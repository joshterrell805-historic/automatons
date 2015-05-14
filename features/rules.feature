Feature: Business Rules

   Background:
      Given the standard business rules

   Scenario: 
      Given "phone" with value "555-555-5555"
      When I run "dashed phone"
      Then "phone" should be "(555) 555-5555"

   Scenario:
      Given "phone" with value "555.555.5555"
      When I run "dotted phone"
      Then "phone" should be "(555) 555-5555"

   Scenario:
      Given "phone" with value "555555555555555"
      When I run "international phone"
      Then "phone" should be "555 55 (555) 555-5555"

