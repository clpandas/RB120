module Displayable
  def format_choices(choices)
    case choices.size
    when 0 then ""
    when 1 then choices.first.to_s
    when 2 then choices.join(" or ")
    else
      "#{choices[0..-2].join(', ')}, or #{choices[-1]}"
    end
  end

  def prompt_player_name
    puts "What's your name?"
  end

  def invalid_name_message
    puts "Sorry, you must enter a name."
  end

  def prompt_turn_order
    puts "Do you want to go first or second? (1 = first, 2 = second)"
  end

  def invalid_turn_order_message
    puts "Sorry, you must choose 1 or 2."
  end

  def prompt_marker_choice
    puts "#{human.name}, do you want to be X or O?"
  end

  def invalid_marker_choice_message
    puts "Sorry, please choose X or O"
  end

  def prompt_square_choice
    puts "Choose a square between (#{format_choices(board.unmarked_keys)}): "
  end

  def invalid_square_choice
    puts "Sorry, you must choose: #{format_choices(board.unmarked_keys)}."
  end

  def prompt_play_again
    puts "Would you like to play again? (y/n)"
  end

  def invalid_play_again_message
    puts "Sorry, enter y or n"
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    puts "#{human.name}, you're a #{human.marker}. #{computer.name} is a #{computer.marker}"
    puts ""
    board.draw
    puts ""
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "#{human.name} won!"
    when computer.marker
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_accessor :marker, :name

  def initialize(marker = nil, name = nil)
    @marker = marker
    @name = name
  end
end

class TTTGame
  include Displayable

  COMPUTER_NAMES = ["Bird", "Cat", "Dog", "Bear", "Fox"]

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new
    @computer = Player.new
    set_player_name
    choose_marker
    assign_computer_marker
    choose_turn_order
  end

  def play
    clear
    display_welcome_message
    main_game
    display_goodbye_message
  end

  private

  def set_player_name
    name = ""
    loop do
      prompt_player_name
      name = gets.chomp
      break unless name.empty?
      invalid_name_message
    end

    human.name = name
    computer.name = COMPUTER_NAMES.sample
  end

  def choose_turn_order
    choice = nil
    loop do      
      prompt_turn_order
      choice = gets.chomp
      break if ["1", "2"].include?(choice)
      invalid_turn_order_message
    end

    @current_marker = choice == "1" ? human.marker : computer.marker
  end

  def choose_marker
    choice = nil
    loop do
      prompt_marker_choice
      choice = gets.chomp.upcase
      break if choice == "X" || choice == "O"
      invalid_marker_choice_message
    end

    human.marker = choice
  end

  def assign_computer_marker
    computer.marker = human.marker == "X" ? "O" : "X"
  end

  def human_moves
    square = nil
    loop do
      prompt_square_choice
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      invalid_square_choice
    end
    board[square] = human.marker
  end

  def computer_moves
    board[board.unmarked_keys.sample] = computer.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
    end
  end

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def main_game
    loop do
      display_board
      player_move
      display_result
      break unless play_again?
      reset
      display_play_again_message
    end
  end

  def human_turn?
    @current_marker == human.marker
  end

  def play_again?
    answer = nil
    loop do
      prompt_play_again
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      invalid_play_again_message
    end

    answer == 'y'
  end

  def clear
    system('cls') || system('clear')
  end

  def reset
    board.reset
    choose_turn_order
    clear
  end
end

game = TTTGame.new
game.play
