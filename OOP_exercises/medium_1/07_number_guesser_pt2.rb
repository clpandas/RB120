# keep guesses_reminaing local
# keep secret_number an instance var
# keep result local
# turn low/high local

class GuessingGame
  def initialize(low, high)
    @range = low..high
    @max_guesses = Math.log2(@range.size).to_i + 1
  end

  def play
    @secret_number = rand(@range)
    guesses_remaining = @max_guesses
    result = nil

    until guesses_remaining.zero?
      display_guesses_remaining(guesses_remaining)
      guess = prompt_for_guess
      case evaluate_guess(guess, @secret_number)
      when :low then puts "Your guess is too low."
      when :high then puts "Your guess is too high."
      when :match
        puts "That's the number!"
        result = :win
        break
      end

      guesses_remaining -= 1
    end

    result ||= :lose
    display_result(result)
  end

  private

    def display_guesses_remaining(guesses_remaining)
      puts
      if guesses_remaining == 1
        puts "You have 1 guess remaining."
      else
        puts "You have #{guesses_remaining} guesses remaining."
      end
    end

    def prompt_for_guess
      loop do
        puts "Enter a number between #{@range.first} and #{@range.last}: "
        guess = gets.to_i
        return guess if @range.cover?(guess)
        puts "Invalid guess. "
      end
    end

    def evaluate_guess(guess, secret_number)
      return :match if guess == secret_number
      return :low   if guess <  secret_number
      :high
    end

    def display_result(result)
      puts
      puts(result == :win ? "You won!" : "You have no more guesses. You lost!")
    end
end

game = GuessingGame.new(501, 1500)
game.play
