require 'sinatra'
require_relative 'hangman'



display = Display.new
trash = Trash.new
lives = Lives.new(9)
hangman_game = Game.new(display, "SUPERLONGWORD", trash, lives)
hangman_game.guess(Guess.new('B'))
hangman_game.guess(Guess.new('A'))


get '/hangman' do
  erb :main, :locals => {:answer => display.message, :lives => lives.number_of_lives, :trash => trash.display}
end

template :main do 
  "<html>" +
    "<head>" +
    "</head>" +
    "<body>" +
      '<text id="answer"> <%= answer %> </text> <br/>' +
      '<input type="text" name="guess"> <br/>' +
      '<input type="submit" value="Guess!" > <br/>'+
      '<text id="lives"> Lives: <%= lives %> </text> <br/>' +
      '<text id="trash"> Trash: <%= trash %> </text> <br/>' +
    "</body>" +
    "</html>"
end