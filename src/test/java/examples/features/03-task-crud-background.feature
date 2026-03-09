# KT Part C
# Concepts demonstrated: Background for base URL, auth token, and authorization header
@part-c
@kt-background
Feature: task CRUD create using background setup

Background:
  # Move common environment setup into Background so the scenario stays shorter.
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
  # Persist the Authorization header for all requests in this scenario.
  * def authToken = response.token
  * configure headers = { Authorization: '#("Bearer " + authToken)' }

Scenario: create a task with auth already prepared in the background
  # The scenario can now focus only on the business action.
  Given path 'api', 'v2', 'tasks'
  And request
    """
    {
      "title": "KT background task",
      "description": "Background keeps the scenario focused on create",
      "status": "TODO",
      "priority": "MEDIUM"
    }
    """
  When method post
  Then status 201
  # Assertions remain inline, but setup duplication is gone.
  And match response.id == '#number'
  And match response.title == 'KT background task'
  And match response.description == 'Background keeps the scenario focused on create'
  And match response.status == 'TODO'
