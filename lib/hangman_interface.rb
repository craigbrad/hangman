require 'sinatra'
require 'sinatra/reloader'
require 'colorize'
require "data_mapper"
require 'ruby-dictionary'
require 'json'

require_relative 'slack'
require_relative 'hangman'

set :bind, '0.0.0.0' 
set :logging, false

path = "://#{Dir.pwd}/games.db"

DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_CYAN_URL'] || path) 

enable :sessions
set :session_secret, 'super secret'

games = []

dictionary = Dictionary.from_file("#{Dir.pwd}/dictionary.txt")

before do
  session[:id] ||= SecureRandom.uuid
end

class GameDB 
  include DataMapper::Resource

  property :id, Serial
  property :game_id, Integer, :required => true
  property :player_id, String, :required => true
  property :active, Boolean, :default => false
  property :score, Integer, :default => 0
  property :finished, Boolean, :default  => false
  property :challenger_id, String, :default => ""
end

class PlayerDB 
  include DataMapper::Resource

  property :id, Serial
  property :player_id, String, :required => true, :unique => true
  property :player_name, String, :required => true, :default => ""  
end


DataMapper.finalize
DataMapper.auto_migrate! 

slack_game = Slack.new

get '/' do
  erb :'/home'
end


post '/slack' do
  @token = params[:token]
  @user_name = params[:user_name]
  @text = params[:text]
  content_type :json
  { :text => slack_game.check_command(@text) + "\ntrash: " + slack_game.game.trash.display }.to_json

  #check for valid token

  #check text for command

  #newgame
  #guess
  #fkfs 
  #if new game - create game - return blanks

  #check if active game
  #if game is active check guess
  #if valid guess return updated blanks
  #if invalid return error message

end



get '/hangman' do
  category = params[:category]

  display = Display.new
  trash = Trash.new
  if settings.environment == 'test'
    lives = Lives.new(3)
    hangman_game = Game.new(display, trash, lives, "test.txt", category)
  else
    lives = Lives.new(10)
    filename = category + ".txt"
    hangman_game = Game.new(display, trash, lives, filename, category)
  end

  games[games.size] = hangman_game
  game = GameDB.newf
  hangman_game_id = games.size - 1
  game.game_id = hangman_game_id
  game.player_id = session[:id]
  game.challenger_id = session[:id]
  game.active = true
  game.save
  session[:game_id] = hangman_game_id

  errormessage = "" 
  greeting = "You are playing the category #{category}!"
  erb :'/hangman', :locals => { :greeting => greeting,
                                :answer => display.message, 
                                :error => errormessage, 
                                :lives => lives.number_of_lives, 
                                :trash => trash.display}
end

get '/unfinished' do
  
  game_records = GameDB.all(:challenger_id => session[:id])
  active_game_records = game_records.all(:active => true)
  unfinished_games = active_game_records.all(:finished => false)
  
  unfinished = []
  game_struct = Struct.new(:game_id, :game)
  unfinished_games.each do |game|
    game_s = game_struct.new(game.game_id, games[game.game_id])
    puts game_s.inspect.to_s.green
    unfinished << game_s
  end

  erb :'/unfinished_games', :locals => { :records => unfinished }
end

get '/resume' do
  game_id = params[:game_id].to_i
  game = games[game_id]
  session[:game_id] = game_id
  errormessage = ""
  greeting = ""
  erb :'/hangman', :locals => { :greeting => greeting,
                                :answer => game.display.message, 
                                :error => errormessage, 
                                :lives => game.lives.number_of_lives, 
                                :trash => game.trash.display}

end

get '/quit' do
  game_id = params[:game_id].to_i
  puts game_id.to_s.red
  game = games[game_id]

  record = GameDB.last( :game_id => game_id )
  puts record.destroy.to_s.blue

  errormessage = ""
  greeting = ""

  status, headers, body = call env.merge("PATH_INFO" => '/unfinished')
end

get '/multiplayer' do
  player = PlayerDB.first(:player_id => session[:id])
  number_of_games = GameDB.all(:active => false).size 
  if player == nil
    name = params[:name]
    if name == nil
      errormessage = ""
      erb :'/newuser', :locals => {:error => errormessage}
    else
      player = PlayerDB.new
      player.player_id = session[:id]
      player.player_name = name
      player.save
      erb :'/multiplayer', :locals => { :name => name, :num_games => number_of_games }
    end
  else
    erb :'/multiplayer', :locals => { :name => player.player_name, :num_games => number_of_games}
  end
end

get '/multiplayer_create' do
  errormessage = ""
  erb :'/create', :locals => { :error => errormessage }
end

get '/multiplayer_submit' do
  answer = params[:answer].downcase

  if !dictionary.exists?(answer)
    errormessage = "Please enter a dictionary word!"
    erb :'/create', :locals => { :error => errormessage }
  elsif answer =~ /^[A-Za-z]*$/ 
    display = Display.new
    trash = Trash.new
    lives = Lives.new(10)
    hangman_game = Game.new(display, trash, lives, answer, "multiplayer")
    games[games.size] = hangman_game

    game = GameDB.new
    game.game_id = games.size - 1
    game.player_id = session[:id]
    game.active = false
    game.save
    redirect '/multiplayer'
  elsif answer == ""
    errormessage = "Please enter a word!"
    erb :'/create', :locals => { :error => errormessage }
  else
    errormessage = "Invalid character please enter only a-z"
    erb :'/create', :locals => { :error => errormessage }
  end
end


get '/multiplayer_play' do
  inactive_games = GameDB.all(:active => false)
  game = inactive_games.find{|record| record.player_id != session[:id] } 

  if game != nil
    game.update( :active => true, :challenger_id => session[:id] )
    hangman_game_id = game.game_id
    hangman_game = games[hangman_game_id]
    errormessage = ""
    session[:game_id] = hangman_game_id
  end

  inactive_games = GameDB.all(:active => false)

  inactive_games.each do |record|
    puts record.inspect.to_s.blue
  end

  if game != nil
      player = PlayerDB.first( :player_id => game.player_id )
      greeting = "You are guessing #{player.player_name}'s word!"
      erb :'/hangman', :locals => { :greeting => greeting,
                                    :answer => hangman_game.display.message, 
                                    :error => errormessage, 
                                    :lives => hangman_game.lives.number_of_lives, 
                                    :trash => hangman_game.trash.display}
  else
    erb :'/nogames'
  end

end

get '/scores' do
  players_games = GameDB.all(:player_id => session[:id].to_s)
  finished_games = players_games.all(:finished => true)
  game_struct = Struct.new(:answer, :lives, :challenger)
  challengers_struct = []
  players_struct = []
  not_played = []

  finished_games.each do |record|
    challenger_id = record.challenger_id
    if challenger_id == session[:id]
      game = game_struct.new( games[record.game_id].get_answer, games[record.game_id].lives.number_of_lives, "you")
      players_struct << game
      puts "YOU".red
    else
      challenger = PlayerDB.first(:player_id => record.challenger_id)
      game = game_struct.new( games[record.game_id].get_answer, games[record.game_id].lives.number_of_lives, challenger.player_name)
      challengers_struct << game
      puts "CHALLENGER".blue
    end
  end

  unplayed_games = players_games.all(:active => false)
  unplayed_games.each do |game| 
    not_played << games[game.game_id].get_answer
  end

  erb :'/scores', :locals => { :challengers => challengers_struct, :players => players_struct, :unplayed => not_played }
end

get '/guess' do
  guess = params[:guess]
  errormessage = ""

  hangman_game = games[session[:game_id]]

  if guess =~ /[A-Za-z]/
    hangman_game.guess(Guess.new(guess)) 
  elsif guess == ""
    errormessage = "Please input something!"
  else
    errormessage = "Invalid input: A-Z Only!"
  end

  if hangman_game.is_won?
    record = GameDB.first( :game_id => session[:game_id] )
    record.update( :score => hangman_game.lives.number_of_lives, :finished => true)
    puts record.inspect.to_s.red
    erb :'/won', :locals => {:answer => hangman_game.get_answer} 
  elsif hangman_game.is_over?
    record = GameDB.first( :game_id => session[:game_id])
    record.update( :score => hangman_game.lives.number_of_lives, :finished => true)
    erb :'/lost', :locals => {:answer => hangman_game.get_answer} 
  else
    if hangman_game.category == "multiplayer"
      game = GameDB.first( :game_id => session[:game_id])
      player = PlayerDB.first( :player_id => game.player_id )
      greeting = "You are guessing #{player.player_name}'s word!"
    else
      greeting = "You are playing the category #{hangman_game.category}!"
    end

    erb :'/hangman', :locals => { :greeting => greeting,
                                  :answer => hangman_game.display.message, 
                                  :error => errormessage, 
                                  :lives => hangman_game.lives.number_of_lives, 
                                  :trash => hangman_game.trash.display}
  end
end

get '/random' do
  input = params[:category]
  catagories = ["halloween", "beach", "sport", "food", "pirates", "computing"]
  category = catagories.sample
  redirect "/hangman?category=#{category}"
end




