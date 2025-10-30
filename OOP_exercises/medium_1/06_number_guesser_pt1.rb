class GuessingGame
  RANGE = 1..100
  MAX_GUESSES = 7

  def play
    reset_game

    until @guesses_remaining.zero?
      display_guesses_remaining
      guess = prompt_for_guess
      result = evaluate_guess(guess)

      case result
      when :low  then puts "Your guess is too low."
      when :high then puts "Your guess is too high."
      when :match
        puts "That's the number!"
        @result = :win
        break
      end

      @guesses_remaining -= 1
    end

    display_result
  end

  private

  def reset_game
    @secret_number = rand(RANGE)
    @guesses_remaining = MAX_GUESSES
    @result = nil
  end

  def display_guesses_remaining
    puts
    if @guesses_remaining == 1
      puts "You have 1 guess remaining."
    else
      puts "You have #{@guesses_remaining} guesses remaining."
    end
  end

  def prompt_for_guess
    loop do
      print "Enter a number between #{RANGE.first} and #{RANGE.last}: "
      guess = gets.to_i
      return guess if RANGE.cover?(guess)
      print "Invalid guess. "
    end
  end

  def evaluate_guess(guess)
    return :match if guess == @secret_number
    return :low   if guess <  @secret_number
    :high
  end

  def display_result
    puts
    @result ||= :lose
    puts(@result == :win ? "You won!" : "You have no more guesses. You lost!")
  end
end

game = GuessingGame.new
game.play