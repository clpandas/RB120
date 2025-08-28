class Move
  VALUES = [:rock, :paper, :scissors, :lizard, :spock]

  def initialize(value)
    @value = value.downcase.to_sym
  end

  def move
    @value
  end

  WINNING_MOVES = {
    rock:     [:scissors, :lizard],
    paper:    [:rock, :spock],
    scissors: [:paper, :lizard],
    lizard:   [:spock, :paper],
    spock:    [:scissors, :rock]
  }

  def >(other_move)
    WINNING_MOVES[move].include?(other_move.move)
  end

  def <(other_move)
    WINNING_MOVES[other_move.move].include?(move)
  end

  def ==(other_move)
    move == other_move.move
  end

  def to_s
    @value.to_s
  end
end

class Player
  attr_accessor :move, :name, :score, :history

  def initialize
    @score = 0
    @history = []
    set_name
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry. Please enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose: rock, paper, scissors, lizard, or spock:"
      choice = gets.chomp.downcase.to_sym
      break if Move::VALUES.include?(choice)
      puts "Invalid choice"
    end
    self.move = Move.new(choice)
    self.history << move
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
    self.history << move
  end
end

# Game Orchestration Engine
class RPSGame
  WINNING_SCORE = 5

  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
    puts "The first to #{WINNING_SCORE} points is the winner!"
  end

  def display_goodbye_message
    puts "Thank you for playing!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      human.score += 1
      puts "#{human.name} gets a point!"
    elsif human.move < computer.move
      computer.score += 1
      puts "#{computer.name} gets a point!"
    else
      puts "It's a tie!"
    end
  end

  def display_scores
    puts "Score: #{human.name} #{human.score} | #{computer.name} #{computer.score}"
  end

  def display_history
    puts "#{human.name}'s recent moves: #{human.history.last(5).join(', ')}"
    puts "#{computer.name}'s recent moves: #{computer.history.last(5).join(', ')}"
  end

  def play_again?
    answer = nil

    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)
      puts "Invalid answer. Must be y or n."
    end

    answer == 'y'
  end

  def play
    display_welcome_message

    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      display_scores
      display_history

      if human.score == WINNING_SCORE
        puts "#{human.name} is the winner!"
        break
      elsif computer.score == WINNING_SCORE
        puts "#{computer.name} is the winner!"
        break
      end

      break unless play_again?
    end

    display_goodbye_message
  end
end

RPSGame.new.play
