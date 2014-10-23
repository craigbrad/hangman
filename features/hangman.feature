Feature: Single game of hangman
  
  Scenario: Player guesses a correct letter
    Given a correct letter
    When the player guesses the correct letter
    Then the letter should be revealed in the answer

  Scenario: Player guesses an incorrect letter 
    Given an incorrect letter
    When the player guesses the incorrect letter
    Then the letter should go into the trash
    And the player should lose a life

  Scenario: Player loses all lives
    Given the player has three lives left
    When the player guesses incorrectly several times
    Then the game should be over

  Scenario: Player guesses all of the letters
    Given there is only one letter left to guess
    When the player guesses the letter correctly
    Then the game should be won

  Scenario: Player guesses correct letter twice
    Given a letter has already been guessed correctly
    When the player guesses that letter again
    Then the player will not lose a life 


  Scenario: Player guesses incorrect letter twice
    Given a letter has already been guessed incorrectly
    When the player guesses the incorrect letter again
    Then the player will lose a life