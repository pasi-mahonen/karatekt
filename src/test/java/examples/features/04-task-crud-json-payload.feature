# KT Part D
# Concepts demonstrated: payload externalization with read() and variable injection
@part-d
@kt-json-payload
Feature: task CRUD create using payload from file

Background:
  # Keep the shared auth flow in Background, same as Part C.
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

Scenario: create a task with JSON payload read from file
  # Define variables first, then inject them into the JSON template via read().
  * def title = 'KT payload task'
  * def description = 'Create payload loaded from a JSON file'
  * def payload = read('classpath:examples/payloads/create-task.json')

  # Submit the externalized payload instead of inline JSON.
  Given path 'api', 'v2', 'tasks'
  And request payload
  When method post
  Then status 201
  # Validate against the same variables used to build the payload.
  And match response.id == '#number'
  And match response.title == title
  And match response.description == description
  And match response.status == payload.status
