# KT Helper
# Concepts demonstrated: reusable authentication via call/callonce
Feature: authenticate and return bearer token

Scenario:
  * def username = __arg.username
  * def password = __arg.password
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
