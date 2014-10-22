require 'hangman'

RSpec.describe "A game of hangman" do
  it "can guess a correct letter" do
    display = Display.new
    trash = Trash.new
    lives = Lives.new(9)
    hangman_game = Game.new(display, "HANGMAN", trash, lives)
    guess = Guess.new('A')
    hangman_game.guess(guess)
    expect(display.message).to eq("_ A _ _ _ A _")
  end
end
