# KT Helper
# Concepts demonstrated: reusable authentication via call/callonce
Feature: authenticate and return bearer token

Scenario:
  * match username == '#string'
  * match password == '#string'
  Given url baseUrl + authPath
  And request
    """
    {
      "username": "#(username)",
      "password": "#(password)"
    }
    """
  When method post
  Then status 200
  And match response.token == '#string'
  * def authToken = response.token
