# KT Part G
# Concepts demonstrated: callonce helper auth, reusable verification helper, JSON payloads, dynamic CSV examples, Java utils, and full CRUD
@part-g
@kt-final
Feature: task CRUD final reusable framework example

Background:
  # Load shared dependencies once so each scenario row can focus on the CRUD lifecycle.
  * url baseUrl
  * def RandomDataUtil = Java.type('examples.util.RandomDataUtil')
  * def authArgs = { username: '#(credentials.username)', password: '#(credentials.password)' }
  * def authResult = callonce read('classpath:examples/helpers/auth.feature') authArgs
  * def authToken = authResult.authToken
  * configure headers = { Authorization: '#("Bearer " + authToken)' }

@setup=qa
Scenario: prepare qa task rows with update values
  * def rows = read('classpath:examples/data/tasks.csv')
  * def rows = karate.filter(rows, function(row){ return row.env == 'qa' && row.run == 'true'; })
  * def rows = karate.map(rows, function(row){ return { env: row.env, title: row.title, description: row.description, priority: row.priority, dueDate: row.dueDate, status: 'IN_PROGRESS', updatePriority: 'HIGH', updateDueDate: '2026-05-05' }; })

@setup=dev
Scenario: prepare dev task rows with update values
  * def rows = read('classpath:examples/data/tasks.csv')
  * def rows = karate.filter(rows, function(row){ return row.env == 'dev' && row.run == 'true'; })
  * def rows = karate.map(rows, function(row){ return { env: row.env, title: row.title, description: row.description, priority: row.priority, dueDate: row.dueDate, status: 'DONE', updatePriority: 'URGENT', updateDueDate: '2026-05-10' }; })

Scenario Outline: create read update and delete a task with reusable helpers for <env> - <title>
  # Build unique create data from CSV-backed example values plus a Java-generated suffix.
  * def suffix = RandomDataUtil.randomAlpha(5)
  * def createTitle = '<title>' + ' ' + suffix
  * def createDescription = '<description>' + ' ' + suffix
  * def createPriority = '<priority>'
  * def createDueDate = '<dueDate>'
  * def title = createTitle
  * def description = createDescription
  * def priority = createPriority
  * def dueDate = createDueDate
  * def createPayload = read('classpath:examples/payloads/create-task.json')

  # Create the task and verify the response through the reusable helper feature.
  Given path 'api', 'v2', 'tasks'
  And request createPayload
  When method post
  Then status 201
  * def taskId = response.id
  * def expected = { id: '#number', title: '#(createTitle)', description: '#(createDescription)', status: 'TODO', priority: '#(createPriority)', dueDate: '#(createDueDate)' }
  * def createVerificationArgs = { response: '#(response)', expected: '#(expected)' }
  * call read('classpath:examples/helpers/task-verification.feature') createVerificationArgs

  # Read the created task back and verify it again.
  Given path 'api', 'v2', 'tasks', taskId
  When method get
  Then status 200
  * def readVerificationArgs = { response: '#(response)', expected: '#(expected)' }
  * call read('classpath:examples/helpers/task-verification.feature') readVerificationArgs

  # Prepare update data from the outline row and reusable payload template.
  * def updateTitle = createTitle + ' updated'
  * def updateDescription = 'Updated description for ' + suffix
  * def status = '<status>'
  * def priority = '<updatePriority>'
  * def dueDate = '<updateDueDate>'
  * def title = updateTitle
  * def description = updateDescription
  * def updatePayload = read('classpath:examples/payloads/update-task.json')
  * def updateExpected = { id: taskId, title: '#(updateTitle)', description: '#(updateDescription)', status: '#(status)', priority: '#(priority)', dueDate: '#(dueDate)' }

  # Update the task and validate the new state.
  Given path 'api', 'v2', 'tasks', taskId
  And request updatePayload
  When method put
  Then status 200
  * def updateVerificationArgs = { response: '#(response)', expected: '#(updateExpected)' }
  * call read('classpath:examples/helpers/task-verification.feature') updateVerificationArgs

  # Read after update to confirm persistence.
  Given path 'api', 'v2', 'tasks', taskId
  When method get
  Then status 200
  * def persistedVerificationArgs = { response: '#(response)', expected: '#(updateExpected)' }
  * call read('classpath:examples/helpers/task-verification.feature') persistedVerificationArgs

  # Delete the task as the final lifecycle action.
  Given path 'api', 'v2', 'tasks', taskId
  When method delete
  Then status 204

  # Confirm the resource no longer exists.
  Given path 'api', 'v2', 'tasks', taskId
  When method get
  Then status 404

@qa
Examples:
  # Load qa CSV rows merged with update fields from the named setup scenario.
  | karate.setup('qa').rows |

@dev
Examples:
  # Load dev CSV rows merged with update fields from the named setup scenario.
  | karate.setup('dev').rows |
