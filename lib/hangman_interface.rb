require 'sinatra'
require 'sinatra/reloader'
require_relative 'hangman'

display = nil 
trash = nil
lives = nil 
hangman_game = nil 

get '/' do
  erb :'/home'
end

get '/hangman' do
  input = params[:category]
  puts Dir.pwd
  display = Display.new
  trash = Trash.new
  if settings.environment == 'test'
    lives = Lives.new(3)
    hangman_game = Game.new(display, trash, lives, "test.txt")
  else
    lives = Lives.new(10)
    filename = input + ".txt"
    hangman_game = Game.new(display, trash, lives, filename)
  end
  errormessage = ""
  erb :'/hangman', :locals => {:answer => display.message, :error => errormessage, :lives => lives.number_of_lives, :trash => trash.display}
end

get '/guess' do
  guess = params[:guess]
  errormessage = ""

  if guess =~ /[A-Za-z]/
    hangman_game.guess(Guess.new(guess)) 
  elsif guess == ""
    errormessage = "Please input something!"
  else
    errormessage = "Invalid input: A-Z Only!"
  end

  if hangman_game.is_won?
    erb :'/won', :locals => { :answer => hangman_game.get_answer } 
  elsif hangman_game.is_over?
    erb :'/lost', :locals => { :answer => hangman_game.get_answer } 
  else
    erb :'/hangman', :locals => {:answer => display.message, :error => errormessage, :lives => lives.number_of_lives, :trash => trash.display}
  end
end