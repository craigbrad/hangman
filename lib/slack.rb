require_relative './hangman'

class Slack
  attr_reader :game

  def check_command(message)
    user_input = parse_message(message)
    if user_input[1] == "newgame"
      new_game
      @game.display.message + "\nLives: " + @game.lives.number_of_lives.to_s
    elsif user_input[1] == "guess"
      if user_input[2] =~ /^[A-Za-z]{1}$/
        @game.guess(Guess.new(user_input[2]))
        message = @game.display.message + "Trash:" + @game.trash.display + "\nLives: " + @game.lives.number_of_lives.to_s
        if @game.is_won?
          message = "Congrats, you guessed " + @game.get_answer + " correctly!"
        elsif @game.is_over?
          message = "Unlucky, the word was " + @game.get_answer
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

  def new_game
    display = Display.new
    trash = Trash.new
    lives = Lives.new(10)
    @game = Game.new(display, trash, lives, "wordlist.txt",  "slack")
  end

  def reset
    @game = nil
  end

  def check_guess
  end

  private
  def parse_message(message)
    message.split(' ', 3)
  end
end
