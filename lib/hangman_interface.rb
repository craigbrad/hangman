require 'sinatra'
require_relative 'hangman'

display = nil 
trash = nil
lives = nil 
hangman_game = nil 

get '/hangman' do
  display = Display.new
  trash = Trash.new
  lives = Lives.new(11)
  hangman_game = Game.new(display, "SUPERLONGWORD", trash, lives)
  errormessage = ""
  erb :'/hangman', :locals => {:answer => display.message, :error => errormessage, :lives => lives.number_of_lives, :trash => trash.display}
end

get '/guess' do
  guess = params[:guess]
  errormessage = ""

  if guess =~ /[A-Za-z]/
    hangman_game.guess(Guess.new(guess)) 
  elsif guess == ""
    errormessage = "Please input something"
  else
    errormessage = "Invalid input only a-z"
  end

  if hangman_game.is_won?
    erb :'/won'  
  elsif hangman_game.is_over?
    erb :'/lost' 
  else
    erb :'/hangman', :locals => {:answer => display.message, :error => errormessage, :lives => lives.number_of_lives, :trash => trash.display}
  end
end