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
        @game.display.message
      else
        "invalid input"
      end
    else
      "no valid command entered"
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
