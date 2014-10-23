class Game
  attr_reader :answer, :display, :trash, :lives, :is_over, :is_won

  def initialize(display, answer, trash, lives)
    @display = display
    @answer = Answer.new(answer)
    @trash = trash
    @lives = lives
    @is_over = false
    @is_won = false
    @display.show(@answer.display)
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
  
  def is_over?
    @is_over
  end

  def is_won?
    @is_won
  end
end

class Guess
  attr_reader :letter

  def initialize(letter)
    @letter = letter.upcase
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
  def display
    used_letters = []
    guesses.each do |guess|
      used_letters << guess.letter
    end
    used_letters
  end
end




class Display
  attr_reader :message
  
  def initialize
    @message = ""
  end
  
  def message
    @message
  end

  def show(message)
    @message = message
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





class Answer
  attr_reader :letters
  
  def initialize(answer)
    @letters = split_answer(answer)
  end

  def split_answer(answer)
    @letters = answer.split('')
    more_letters = []
    letters.each do |letter|
      more_letters << Letter.new(letter)
    end
    more_letters
  end

  def check_guess(guess)
    flag = false
    letters.each do |letter|
      if letter.letter == guess.letter
        letter.reveal
        flag = true
      end
    end
    flag
  end

  def is_complete?
    letters.each do |letter|
      if !letter.is_revealed
       return false
      end
    end
    true
  end

  def display
    message = ""
    letters.each do |letter|
      if letter.is_revealed
        message << letter.letter << " "
      else
        message << "_" << " "
      end
    end
    message.strip
  end

  private
  class Letter
    attr_reader :letter, :is_revealed

    def initialize(letter)
      @letter = letter
      @is_revealed = false
    end

    def reveal
      @is_revealed = true
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