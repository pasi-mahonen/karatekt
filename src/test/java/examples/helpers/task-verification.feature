# KT Helper
# Concepts demonstrated: reusable response assertions without HTTP calls
Feature: verify task response payload

Scenario:
  * def actual = __arg.response
  * def expected = __arg.expected
  * match actual.id == '#number'
  * if (expected.id != null) karate.match(actual.id, expected.id)
  * if (expected.title != null) karate.match(actual.title, expected.title)
  * if (expected.description != null) karate.match(actual.description, expected.description)
  * if (expected.status != null) karate.match(actual.status, expected.status)
  * if (expected.completed != null) karate.match(actual.status == 'DONE', expected.completed)
