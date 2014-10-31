require_relative './hangman'

class Slack
  attr_reader :game

  def check_command(message)
    user_input = parse_message(message)
    if user_input[1] == "newgame"
      new_game
      @game.display.message
    elsif user_input[1] == "guess"
      if user_input[2] =~ /^[A-Za-z]{1}$/
        @game.guess(Guess.new(user_input[2]))
        if game.is_won?
          "Congrats, you guessed " + game.get_answer + "correctly!"
        elsif game.is_lost?

        end
        @game.display.message
      else
        "Invalid input"
      end
    elsif user_input[1] == "help"
      "*hangman newgame* - Allows you to start a new game\n*hangman guess 'your guess'* - Allows you to make a guess"
    else
      "No valid command entered, try typing 'hangman help' for a list of commands"
    end
  end

  def new_game
    display = Display.new
    trash = Trash.new
    lives = Lives.new(10)
    @game = Game.new(display, trash, lives, "wordlist.txt",  "slack")
  end

  def check_guess
  end

  private
  def parse_message(message)
    message.split(' ', 3)
  end
end
