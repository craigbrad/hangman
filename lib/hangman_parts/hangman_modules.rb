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
    used_letters = ""
    guesses.each do |guess|
      used_letters << guess.letter << ", "
    end
    used_letters.chomp(", ")
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
    @number_of_lives == 0
  end
end

