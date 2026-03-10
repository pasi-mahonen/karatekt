# KT Part E
# Concepts demonstrated: filtered CSV data source in dynamic Scenario Outline examples
@part-e
@kt-csv-data
Feature: task CRUD create using CSV-driven data

Background:
  # Shared setup still lives in Background.
  * url baseUrl
  Given path 'api', 'v2', 'auth', 'login'
  And request
    """
    {
      "username": "#(credentials.username)",
      "password": "#(credentials.password)"
    }
    """
  When method post
  Then status 200
  * def authToken = response.token
  * configure headers = { Authorization: '#("Bearer " + authToken)' }

Scenario Outline: create a task from CSV row for <env> - <title>
  # The placeholders come directly from CSV rows filtered in the Examples table.
  * def title = '<title>'
  * def description = '<description>'
  * def priority = '<priority>'
  * def dueDate = '<dueDate>'
  * def payload = read('classpath:examples/payloads/create-task.json')

  # Send the request built from external CSV data plus external JSON payload.
  Given path 'api', 'v2', 'tasks'
  And request payload
  When method post
  Then status 201
  # Confirm the API persisted the filtered row values.
  And match response.id == '#number'
  And match response.title == title
  And match response.description == description
  And match response.status == 'TODO'
  And match response.priority == priority
  And match response.dueDate == dueDate

@qa
Examples:
  # Load runnable qa rows directly from the CSV file.
  | read('classpath:examples/data/tasks.csv').filter(function(row){ return row.env == 'qa' && row.run == 'true'; }) |

@dev
Examples:
  # Load runnable dev rows directly from the CSV file.
  | read('classpath:examples/data/tasks.csv').filter(function(row){ return row.env == 'dev' && row.run == 'true'; }) |
