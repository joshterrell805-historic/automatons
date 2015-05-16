Feature: Business Rules
   This documents the business rules we have established for the application.
   Cleanse rules are described by a name and their effect on a simple example.

   Background:
      Given the standard business rules

   Scenario: 
      Given "phone" with value "555-555-5555"
      When I run the "dashed phone" rule
      Then "phone" should be "(555) 555-5555"

   Scenario:
      Given "phone" with value "555.555.5555"
      When I run the "dotted phone" rule
      Then "phone" should be "(555) 555-5555"

   Scenario:
      Given "phone" with value "011555555555555"
      When I run the "international phone" rule
      Then "phone" should be "011 55 (555) 555-5555"

