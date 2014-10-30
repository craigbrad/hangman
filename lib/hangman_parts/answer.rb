class Answer
  attr_reader :letters, :answer
  
  def initialize(filename)
    @letters = generate_answer(filename)
    letters.each do |letter|
      print letter.letter.red
    end
  end

  def generate_answer(filename)
    words = []
    puts Dir.pwd.to_s.red
    if filename.include? ".txt"
      file_name = Dir.pwd + "/" + filename
      f = File.open(file_name, "r")
      f.each do |line|
        words[words.count] = line
      end
      @answer = words.sample.strip.upcase
    else
      @answer = filename.strip.upcase
    end
    split_answer(answer)
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

  def get_answer
    @answer
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