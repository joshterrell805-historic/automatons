Feature: Cleanse rule format
   As a developer
   I want a clean syntax for cleanse rules
   In order to specify the transformations required on the data

   Scenario: Basic aaa -> bbb rule
      Given this cleanse rule:
      """
      rule :field, /a+/, "change all a's" do |string|
        "bbb"
      end
      """
      And data with "field" set to "aaa"
      When I run the cleanse
      Then "field" should be "bbb"

   Scenario: Another basic rule
      Given this cleanse rule:
      """
      rule :thing, /pty/, "change pty to ppp" do |string|
        "ppp"
      end
      """
      And data with "thing" set to "pty"
      When I run the cleanse
      Then "thing" should be "ppp"

      @wip
   Scenario:
      Given this cleanse rule:
      """
      every /^\s|\s$/, "clean string" do |field, data|
         str.strip
      end
      """
      And data with "thing" set to "    string   "
      When I run the cleanse
      Then "thing" should be "string"

