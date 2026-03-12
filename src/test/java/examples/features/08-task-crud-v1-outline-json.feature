# KT Part H
# Concepts demonstrated: v1 public API CRUD, Scenario Outline, reusable JSON payloads, reusable verification helper
@part-h
@kt-v1-crud
Feature: task CRUD for the v1 public API using outline rows and JSON payload files

Background:
  * url baseUrl
  * def RandomDataUtil = Java.type('examples.util.RandomDataUtil')

Scenario Outline: create read update and delete a v1 task for <title>
  # Add a random suffix so repeated executions do not collide with old demo data.
  * def suffix = RandomDataUtil.randomAlphanumeric(6)
  * def createTitle = '<title>' + ' ' + suffix
  * def createDescription = '<description>' + ' ' + suffix
  * def createPriority = '<priority>'
  * def createDueDate = '<dueDate>'
  * def title = createTitle
  * def description = createDescription
  * def priority = createPriority
  * def dueDate = createDueDate
  * def createPayload = read('classpath:examples/payloads/create-task.json')

  # Create a task from the external JSON template.
  Given path 'api', 'v1', 'tasks'
  And request createPayload
  When method post
  Then status 201
  * def taskId = response.id
  * def createExpected = { id: '#number', title: '#(createTitle)', description: '#(createDescription)', status: 'TODO', priority: '#(createPriority)', dueDate: '#(createDueDate)' }
  * def createVerificationArgs = { response: '#(response)', expected: '#(createExpected)' }
  * call read('classpath:examples/helpers/task-verification.feature') createVerificationArgs

  # Read the created task back by id.
  Given path 'api', 'v1', 'tasks', taskId
  When method get
  Then status 200
  * def readVerificationArgs = { response: '#(response)', expected: '#(createExpected)' }
  * call read('classpath:examples/helpers/task-verification.feature') readVerificationArgs

  # Prepare the update body from a second JSON template.
  * def updateTitle = createTitle + ' updated'
  * def updateDescription = 'Updated ' + createDescription
  * def status = '<updateStatus>'
  * def priority = '<updatePriority>'
  * def dueDate = '<updateDueDate>'
  * def title = updateTitle
  * def description = updateDescription
  * def updatePayload = read('classpath:examples/payloads/update-task.json')
  * def updateExpected = { id: taskId, title: '#(updateTitle)', description: '#(updateDescription)', status: '#(status)', priority: '#(priority)', dueDate: '#(dueDate)' }

  # Update the task and confirm the new state.
  Given path 'api', 'v1', 'tasks', taskId
  And request updatePayload
  When method put
  Then status 200
  * def updateVerificationArgs = { response: '#(response)', expected: '#(updateExpected)' }
  * call read('classpath:examples/helpers/task-verification.feature') updateVerificationArgs

  # Read again after update to confirm persistence.
  Given path 'api', 'v1', 'tasks', taskId
  When method get
  Then status 200
  * def persistedVerificationArgs = { response: '#(response)', expected: '#(updateExpected)' }
  * call read('classpath:examples/helpers/task-verification.feature') persistedVerificationArgs

  # Delete the task and confirm it no longer exists.
  Given path 'api', 'v1', 'tasks', taskId
  When method delete
  Then status 204

  Given path 'api', 'v1', 'tasks', taskId
  When method get
  Then status 404

Examples:
  | title                  | description                              | priority | dueDate    | updateStatus | updatePriority | updateDueDate |
  | KT v1 outline task one | Created through v1 JSON payload template | MEDIUM   | 2026-04-22 | IN_PROGRESS  | HIGH           | 2026-05-02    |
  | KT v1 outline task two | Second v1 CRUD row using external JSON   | LOW      | 2026-04-28 | DONE         | URGENT         | 2026-05-09    |