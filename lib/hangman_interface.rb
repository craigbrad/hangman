require 'sinatra'
require_relative 'hangman'



display = nil 
trash = nil
lives = nil 
hangman_game = nil 

get '/hangman' do
  display = Display.new
  trash = Trash.new
  lives = Lives.new(3)
  hangman_game = Game.new(display, "SUPERLONGWORD", trash, lives)
  errormessage = ""
  erb :main, :locals => {:answer => display.message,  :error => errormessage, :lives => lives.number_of_lives, :trash => trash.display}
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
    erb :won  
  elsif hangman_game.is_over?
    erb :lost 
  else
    erb :main, :locals => {:answer => display.message, :error => errormessage, :lives => lives.number_of_lives, :trash => trash.display}
  end
end

template :won do
  "<html>" +
    "<head>" +
    "</head>" +
    "<body>" +
      '<text> CONGRATULATIONS YOU HAVE WON! </text>' +
    "</body>" +
  "</html>"
end

template :lost do
  "<html>" +
    "<head>" +
    "</head>" +
    "<body>" +
    '<text> UNLUCKY YOU HAVE LOST! </text>' +
    "</body>" +
  "</html>"
end

template :main do 
  "<html>" +
    "<head>" +
      "<title>Hangman</title>"
    "</head>" +
    "<body>" +
      '<text id="answer"> <%= answer %> </text> <br/>' +
      '<form method="get" action="/guess">' +
        '<input type="text" name="guess"  maxlength="1"> <br/>' +
        '<input type="submit" id="submit" value="Guess!" > <br/>'+
      '</form>' +
      '<text id="lives"> Lives: <%= lives %> </text> <br/>' +
      '<text id="trash"> Trash: <%= trash %> </text> <br/>' +
      '<text id="error"> <%= error %> </text> <br/>' +
    "</body>" +
  "</html>"
end