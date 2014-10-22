require 'hangman'

RSpec.describe "A player of hangman" do

  it "can guess a correct letter" do
    display = Display.new
    trash = Trash.new
    lives = Lives.new(9)
    hangman_game = Game.new(display, "HANGMAN", trash, lives)
    guess = Guess.new('A')
    hangman_game.guess(guess)
    expect(display.message).to eq("_ A _ _ _ A _")
  end

  it "can guess an incorrect letter" do
    display = Display.new
    trash = Trash.new
    lives = Lives.new(9)
    hangman_game = Game.new(display, "HANGMAN", trash, lives)
    guess = Guess.new('B')
    hangman_game.guess(guess)
    expect(lives.number_of_lives).to eq 8
    expect(trash.guesses.include?(guess)).to be(true) 
  end

  it "can lose a game" do
    display = Display.new
    trash = Trash.new
    lives = Lives.new(1)
    hangman_game = Game.new(display, "HANGMAN", trash, lives)
    guess = Guess.new('B')
    hangman_game.guess(guess)
    expect(hangman_game.is_over).to be true
  end

  it "can guess correctly multiple times" do
    display = Display.new
    trash = Trash.new
    lives = Lives.new(1)
    hangman_game = Game.new(display, "HANGMAN", trash, lives)
    hangman_game.guess(Guess.new('G'))
    hangman_game.guess(Guess.new('A'))
    hangman_game.guess(Guess.new('N'))
    expect(display.message).to eq("_ A N G _ A N")
  end

  it "can guess multiple incorrect guesses" do
    display = Display.new
    trash = Trash.new
    lives = Lives.new(9)
    hangman_game = Game.new(display, "HANGMAN", trash, lives)
    hangman_game.guess(Guess.new('Z')) 
    hangman_game.guess(Guess.new('W')) 
    hangman_game.guess(Guess.new('X')) 
    expect(lives.number_of_lives).to eq 6
  end

  it "can guess correct and incorrect guesses" do
    display = Display.new
    trash = Trash.new
    lives = Lives.new(9)
    hangman_game = Game.new(display, "HANGMAN", trash, lives)
    hangman_game.guess(Guess.new('A')) 
    hangman_game.guess(Guess.new('I')) 
    hangman_game.guess(Guess.new('E')) 
    hangman_game.guess(Guess.new('G'))
    expect(lives.number_of_lives).to eq 7
    expect(display.message).to eq("_ A _ G _ A _")
  end

  it "can guess incorrectly and view old guesses" do
    display = Display.new
    trash = Trash.new
    lives = Lives.new(9)
    hangman_game = Game.new(display, "HANGMAN", trash, lives)
    hangman_game.guess(Guess.new('I')) 
    hangman_game.guess(Guess.new('Y'))
    expect(trash.display).to eq ['I','Y']
  end

  it "can play a full realistic game and lose" do
    display = Display.new
    trash = Trash.new
    lives = Lives.new(7)
    hangman_game = Game.new(display, "MANCHESTER", trash, lives)
    hangman_game.guess(Guess.new('A')) 
    hangman_game.guess(Guess.new('I')) 
    hangman_game.guess(Guess.new('E')) 
    hangman_game.guess(Guess.new('O'))
    hangman_game.guess(Guess.new('U'))
    hangman_game.guess(Guess.new('J'))
    hangman_game.guess(Guess.new('H'))
    hangman_game.guess(Guess.new('S'))
    hangman_game.guess(Guess.new('T'))
    hangman_game.guess(Guess.new('Y'))
    hangman_game.guess(Guess.new('X'))
    hangman_game.guess(Guess.new('Z'))

    expect(hangman_game.is_over).to be true
    expect(lives.number_of_lives).to eq 0
    expect(trash.display).to eq ['I','O', 'U', 'J', 'Y', 'X', 'Z']
    expect(display.message).to eq("_ A _ _ H E S T E _")
  end

  it "can play a full realitic game and win" do
    display = Display.new
    trash = Trash.new
    lives = Lives.new(7)
    hangman_game = Game.new(display, "MANCHESTER", trash, lives)
    hangman_game.guess(Guess.new('A')) 
    hangman_game.guess(Guess.new('E')) 
    hangman_game.guess(Guess.new('O'))
    hangman_game.guess(Guess.new('H'))
    hangman_game.guess(Guess.new('S'))
    hangman_game.guess(Guess.new('T'))
    hangman_game.guess(Guess.new('R'))
    hangman_game.guess(Guess.new('M'))
    hangman_game.guess(Guess.new('N'))
    hangman_game.guess(Guess.new('C'))


    expect(hangman_game.is_won).to be true
    expect(lives.number_of_lives).to eq 6
    expect(trash.display).to eq ['O']
    expect(display.message).to eq("M A N C H E S T E R")
  end
end
