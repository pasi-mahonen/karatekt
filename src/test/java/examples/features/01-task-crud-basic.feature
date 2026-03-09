# KT Part A
# Concepts demonstrated: inline authentication, inline payload, inline assertions
@part-a
@kt-basic
Feature: task CRUD basic create example

Scenario: authenticate and create a task with everything inline
  # First log in directly inside the scenario so every step stays visible.
  Given url baseUrl + authPath
  And request
    """
    {
      "username": "#(credentials.username)",
      "password": "#(credentials.password)"
    }
    """
  When method post
  Then status 200
  # Save the JWT token for the task creation call.
  * def authToken = response.token

  # Create the task with an inline JSON payload.
  Given url baseUrl + tasksPath
  And header Authorization = 'Bearer ' + authToken
  And request
    """
    {
      "title": "KT basic task",
      "description": "Created with inline JSON payload",
      "status": "TODO",
      "priority": "MEDIUM",
      "dueDate": "2026-04-10"
    }
    """
  When method post
  Then status 201
  # Keep assertions inline to show the most direct Karate style.
  And match response.id == '#number'
  And match response.title == 'KT basic task'
  And match response.description == 'Created with inline JSON payload'
  And match response.status == 'TODO'
  And match response.priority == 'MEDIUM'
  And match response.dueDate == '2026-04-10'
  And match response.createdAt == '#string'
  And match response.updatedAt == '#string'
