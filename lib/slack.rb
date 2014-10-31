require_relative './hangman'

class Slack
  attr_accessor :games

  def initialize
    games = {}
  end

  def check_command(message, channel_id)
    user_input = parse_message(message)
    if user_input[1] == "newgame"
      new_game(channel_id)
      @games[channel_id].display.message + "\nLives: " + @game.lives.number_of_lives.to_s
    elsif user_input[1] == "guess"
      if user_input[2] =~ /^[A-Za-z]{1}$/
        @games[channel_id].guess(Guess.new(user_input[2]))
        message = @games[channel_id].display.message + "\nTrash:" + @games[channel_id].trash.display + "\nLives: " + @games[channel_id].lives.number_of_lives.to_s
        if @games[channel_id].is_won?
          message = "Congrats, you guessed " + @games[channel_id].get_answer + " correctly!"
          @games[channel_id] = nil
        elsif @game[channel_id].is_over?
          message = "Unlucky, the word was " + @games[channel_id].get_answer
          @games[channel_id] = nil
        end
        message 
      else
        "Invalid input"
      end
    elsif user_input[1] == "help"
      "*hangman newgame* - Allows you to start a new game\n*hangman guess 'your guess'* - Allows you to make a guess"
    else
      "No valid command entered, try typing 'hangman help' for a list of commands"
    end
  end

  def new_game(channel_id)
    display = Display.new
    trash = Trash.new
    lives = Lives.new(10)
    @games[channel_id] ||= Game.new(display, trash, lives, "dictionary.txt",  "slack")
  end

  def reset(channel_id)
    @games[channel_id] = nil
  end

  def check_guess
  end

  private
  def parse_message(message)
    message.split(' ', 3)
  end
end
