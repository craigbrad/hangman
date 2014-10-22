require 'hangman'

Given(/^a correct letter$/) do
  self.the_guess = Guess.new('A')
end

When(/^the player guesses the letter$/) do
  self.the_display = Display.new
  self.trash = Trash.new
  self.lives = Lives.new(9)
  self.hangman_game = Game.new(the_display, 'HANGMAN', trash, lives)
  hangman_game.guess(the_guess)
end

Then(/^the letter should be revealed in the answer$/) do
  expect(the_display.message).to eq("_ A _ _ _ A _") 
end

Given(/^an incorrect letter$/) do
  self.the_guess = Guess.new('B')
end

Then(/^the letter should go into the trash$/) do
  expect(trash.guesses.include?(self.the_guess)).to be(true) 
end

Then(/^the player should lose a life$/) do
  expect(lives.number_of_lives).to eq 8
end

Given(/^the player has one life left$/) do
  self.lives = Lives.new(1)
end

When(/^the player guesses incorrectly$/) do
  self.the_guess = Guess.new('B')
  self.trash = Trash.new
  self.hangman_game = Game.new(the_display, 'HANGMAN', trash, lives)
  hangman_game.guess(the_guess)
end

Then(/^the game should be over$/) do
  expect(self.hangman_game.is_over).to be true
end

Given(/^there is only one letter left to guess$/) do
  self.trash = Trash.new
  self.lives = Lives.new(9)
  self.the_display = Display.new
  self.hangman_game = Game.new(the_display, 'A', trash, lives)
end

When(/^the player guesses the letter correctly$/) do
  self.the_guess = Guess.new('A')
  hangman_game.guess(the_guess)
end

Then(/^the game should be won$/) do
  expect(self.hangman_game.is_won).to be true
end

Given(/^a letter has already been guessed correctly$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^the player guesses that letter again$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^the player will not lose a life$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^a letter has already been guessed incorrectly$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^the player will lose a life$/) do
  pending # express the regexp above with the code you wish you had
end

World(Helper)