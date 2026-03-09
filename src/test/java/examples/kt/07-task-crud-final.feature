# KT Part G
# Concepts demonstrated: callonce helper auth, reusable verification helper, JSON payloads, CSV data, Java utils, and full CRUD
@part-g
@kt-final
Feature: task CRUD final reusable framework example

Background:
  # Load shared dependencies once so each scenario row can focus on the CRUD lifecycle.
  * url baseUrl
  * def RandomDataUtil = Java.type('examples.util.RandomDataUtil')
  * def authResult = callonce read('classpath:examples/helpers/auth.feature') { username: '#(credentials.username)', password: '#(credentials.password)' }
  * def authToken = authResult.authToken
  * configure headers = { Authorization: '#("Bearer " + authToken)' }
  # Prepare reusable CSV-driven seed data for the scenario outline.
  * def rows = read('classpath:examples/data/tasks.csv')
  * def filteredRows = karate.filter(rows, function(row){ return row.env == 'qa' && row.run == 'true'; })
  * match filteredRows == '#[1]'
  * def selected = filteredRows[0]

Scenario Outline: create read update and delete a task with reusable helpers
  # Build unique create data from CSV plus a Java-generated suffix.
  * def suffix = RandomDataUtil.randomAlpha(5)
  * def createTitle = selected.title + ' ' + suffix
  * def createDescription = selected.description + ' ' + suffix
  * def title = createTitle
  * def description = createDescription
  * def createPayload = read('classpath:examples/payloads/create-task.json')

  # Create the task and verify the response through the reusable helper feature.
  Given path 'api', 'v2', 'tasks'
  And request createPayload
  When method post
  Then status 201
  * def taskId = response.id
  * def expected = { id: '#number', title: '#(createTitle)', description: '#(createDescription)', status: 'TODO', completed: false }
  * call read('classpath:examples/helpers/task-verification.feature') { response: '#(response)', expected: '#(expected)' }

  # Read the created task back and verify it again.
  Given path 'api', 'v2', 'tasks', taskId
  When method get
  Then status 200
  * call read('classpath:examples/helpers/task-verification.feature') { response: '#(response)', expected: '#(expected)' }

  # Prepare update data from the outline row and reusable payload template.
  * def updateTitle = createTitle + ' updated'
  * def updateDescription = 'Updated description for ' + suffix
  * def status = '<status>'
  * def title = updateTitle
  * def description = updateDescription
  * def updatePayload = read('classpath:examples/payloads/update-task.json')
  * def updateExpected = { id: taskId, title: updateTitle, description: updateDescription, status: status, completed: <completed> }

  # Update the task and validate the new state.
  Given path 'api', 'v2', 'tasks', taskId
  And request updatePayload
  When method put
  Then status 200
  * call read('classpath:examples/helpers/task-verification.feature') { response: '#(response)', expected: '#(updateExpected)' }

  # Read after update to confirm persistence.
  Given path 'api', 'v2', 'tasks', taskId
  When method get
  Then status 200
  * call read('classpath:examples/helpers/task-verification.feature') { response: '#(response)', expected: '#(updateExpected)' }

  # Delete the task as the final lifecycle action.
  Given path 'api', 'v2', 'tasks', taskId
  When method delete
  Then status 204

  # Confirm the resource no longer exists.
  Given path 'api', 'v2', 'tasks', taskId
  When method get
  Then status 404

Examples:
  # Each row demonstrates a different update state in the same reusable CRUD flow.
  | status        | completed |
  | IN_PROGRESS   | false     |
  | DONE          | true      |
