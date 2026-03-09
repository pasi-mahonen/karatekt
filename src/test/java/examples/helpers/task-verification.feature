# KT Helper
# Concepts demonstrated: reusable response assertions without HTTP calls
Feature: verify task response payload

Scenario:
  * match response == '#object'
  * match expected == '#object'
  * def actual = response
  * def expectedTask = expected
  * match actual.id == '#number'
  * match actual.priority == '#string'
  * match actual.createdAt == '#string'
  * match actual.updatedAt == '#string'
  * if (expectedTask.id != null) karate.match(actual.id, expectedTask.id)
  * if (expectedTask.title != null) karate.match(actual.title, expectedTask.title)
  * if (expectedTask.description != null) karate.match(actual.description, expectedTask.description)
  * if (expectedTask.status != null) karate.match(actual.status, expectedTask.status)
  * if (expectedTask.priority != null) karate.match(actual.priority, expectedTask.priority)
  * if (expectedTask.dueDate != null) karate.match(actual.dueDate, expectedTask.dueDate)
