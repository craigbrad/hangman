require_relative './hangman_parts/answer'
require_relative './hangman_parts/hangman_modules'

require 'colorize'
class Game
  attr_reader :answer, :display, :trash, :lives, :is_over, :is_won

  def initialize(display, trash, lives, filename = "dictionary.txt", category)
    @display = display
    @answer = Answer.new(filename)
    @trash = trash
    @lives = lives
    @is_over = false
    @is_won = false
    @display.show(@answer.display)
    @category = category
  end

  def guess(guess)
    if answer.check_guess(guess)
      @is_won = answer.is_complete?
      display.show(answer.display)
    else
      trash.add(guess)
      lives.take_a_life
      @is_over = lives.no_lives?
    end
  end

  def get_answer
    @answer.get_answer
  end
  
  def is_over?
    @is_over
  end

  def is_won?
    @is_won
  end

  def category
    @category
  end

end