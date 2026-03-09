# KT Part B
# Concepts demonstrated: Scenario Outline, Examples table, inline authentication and assertions
@part-b
@kt-outline
Feature: task CRUD create with scenario outline

Scenario Outline: authenticate and create a task with example-driven values
  # Authenticate inline again so Part B only changes the data-driving technique.
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
  # Reuse the token for the create request in this outline row.
  * def authToken = response.token

  # Inject row values from the Examples table into the inline payload.
  Given url baseUrl + tasksPath
  And header Authorization = 'Bearer ' + authToken
  And request
    """
    {
      "title": "<title>",
      "description": "<description>",
      "status": "TODO",
      "priority": "<priority>",
      "dueDate": "<dueDate>"
    }
    """
  When method post
  Then status 201
  # Verify that the created resource reflects the current example row.
  And match response.id == '#number'
  And match response.title == '<title>'
  And match response.description == '<description>'
  And match response.status == 'TODO'
  And match response.priority == '<priority>'
  And match response.dueDate == '<dueDate>'

Examples:
  # Each row becomes a separate execution of the same scenario steps.
  | title                  | description                          | priority | dueDate    |
  | KT outline task one    | Created from the first outline row   | MEDIUM   | 2026-04-12 |
  | KT outline task two    | Created from the second outline row  | HIGH     | 2026-04-18 |
