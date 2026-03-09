# KT Part E
# Concepts demonstrated: CSV data loading and row filtering
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

Scenario: create a task from the qa row flagged to run
  # Read all CSV rows, then filter to the one intended for this environment and run flag.
  * def rows = read('classpath:examples/data/tasks.csv')
  * def filtered = karate.filter(rows, function(row){ return row.env == 'qa' && row.run == 'true'; })
  * match filtered == '#[1]'
  * def selected = filtered[0]
  # Map the selected row into the payload variables.
  * def title = selected.title
  * def description = selected.description
  * def priority = selected.priority
  * def dueDate = selected.dueDate
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
