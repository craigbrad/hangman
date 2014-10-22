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
  pending # express the regexp above with the code you wish you had
end

When(/^the player guesses the letter correctly$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^the game should be won$/) do
  pending # express the regexp above with the code you wish you had
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

class Guess
  attr_reader :letter

  def initialize(letter)
    @letter = letter
  end
end

class Game
  attr_reader :answer, :display, :trash, :lives, :is_over

  def initialize(display, answer, trash, lives)
    @display = display
    @answer = answer
    @trash = trash
    @lives = lives
    @is_over = false
  end

  def guess(guess)
    trash.add(guess)
    lives.take_a_life
    is_over?
  end

  private
  def is_over?
    if lives.no_lives?
      @is_over = true
    end
  end
end

class Trash
  attr_reader :guesses
  def initialize
    @guesses = []
  end
  def add(guess)
    @guesses << guess
  end
end

class Display
  attr_reader :message
  
  def initialize
    @message = "_ A _ _ _ A _"
  end
  
  def message
    @message
  end
end

class Lives
  attr_reader :number_of_lives
  def initialize(lives)
    @number_of_lives = lives
  end

  def take_a_life
    @number_of_lives -= 1
  end

  def no_lives?
    if @number_of_lives == 0
      true
    else
      false
    end
  end
end

module Helper
  def the_guess=(guess)
    @the_guess = guess
  end

  def the_guess
    @the_guess
  end

  def the_display=(display)
    @the_display = display
  end

  def the_display
    @the_display
  end

  def trash=(trash)
    @trash = trash
  end

  def trash
    @trash
  end

  def lives=(lives)
    @lives = lives
  end

  def lives
    @lives
  end

  def hangman_game=(game)
    @hangman_game = game
  end

  def hangman_game
    @hangman_game
  end

end
World(Helper)