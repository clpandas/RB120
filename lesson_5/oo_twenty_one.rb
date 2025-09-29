module Hand
  def hit(card)
    cards << card
  end

  def total
    values = cards.map(&:value)
    sum = values.sum

    cards.count { |card| card.rank == "Ace" }.times do
      sum -= 10 if sum > 21
    end

    sum
  end

  def busted?
    total > 21
  end
end

class Player
  include Hand
  attr_reader :name, :cards

  def initialize(name)
    @name = name
    @cards = []
  end
end

class Dealer
  include Hand
  attr_reader :cards

  def initialize
    @cards = []
  end
end

class Card
  SUITS = ['H', 'C', 'D', 'S']
  RANKS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  SUIT_SYMBOLS = { "H" => "♥", "D" => "♦", "C" => "♣", "S" => "♠" }

  attr_reader :suit, :rank

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def to_s
    "#{rank}#{SUIT_SYMBOLS[suit]}"
  end

  def value
    case rank
    when 'A' then 11
    when 'J', 'Q', 'K' then 10
    else rank.to_i
    end
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = Card::SUITS.product(Card::RANKS).map do |suit, rank|
      Card.new(suit, rank)
    end
    shuffle!
  end

  def shuffle!
    cards.shuffle!
  end

  def deal
    cards.pop
  end
end

class Game
  def initialize
    @deck = Deck.new
    puts "What's your name?"
    player_name = gets.chomp
    @player = Player.new(player_name)
    @dealer = Dealer.new
  end

  def start
    puts "Welcome to Twenty-One, #{name}!"
    loop do
      clear_screen
      deal_initial_cards
      show_initial_cards
      sleep(1)
      player_turn
      sleep(1)
      dealer_turn unless @player.busted?
      sleep(1)
      show_result
      sleep(2)
      break unless play_again?
      reset
    end

    puts "Thank you for playing!"
  end

  private

  def clear_screen
    system("clear") || system("cls")
  end

  def name
    @player.name
  end

  def deal_initial_cards
    2.times do
      @player.hit(@deck.deal)
      @dealer.hit(@deck.deal)
    end
  end

  def show_initial_cards
    puts "Dealer shows: #{@dealer.cards.first} and [?]"
    puts "#{@player.name}, you have: #{format_hand(@player.cards)} (Total: #{@player.total})"
  end

  def format_hand(cards)
    cards.map(&:to_s).join(" ")
  end

  def player_turn
    loop do
      puts "Choose: (h)it or (s)tay"
      choice = gets.chomp.downcase
      if choice == "h" || choice == "hit"
        @player.hit(@deck.deal)
        clear_screen
        puts "You hit! Your cards: #{format_hand(@player.cards)} (Total: #{@player.total})"
      elsif choice == "s" || choice == "stay"
        puts "You stay at #{@player.total}."
        break
      else
        puts "Invalid choice. Please choose (h)it or (s)tay."
      end
      break if @player.busted?
    end
  end

  def dealer_turn
    clear_screen
    puts "Dealer's turn..."
    sleep(2)

    while @dealer.total < 17
      @dealer.hit(@deck.deal)
      puts "Dealer hits: #{format_hand(@dealer.cards)} (Total: #{@dealer.total})"
      sleep(1)
    end
    puts "Dealer stays at #{@dealer.total}" unless @dealer.busted?
  end

  def show_result
    clear_screen
    puts "----------"
    puts "Dealer has: #{format_hand(@dealer.cards)} (Total: #{@dealer.total})"
    puts "#{@player.name} has: #{format_hand(@player.cards)} (Total: #{@player.total})"
    puts "----------"

    if @player.busted?
      puts "You busted. Dealer wins!"
    elsif @dealer.busted?
      puts "Dealer busted. You win!"
    elsif @player.total > @dealer.total
      puts "You win!"
    elsif @player.total < @dealer.total
      puts "Dealer wins!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    puts "Play again? (y/n)"
    gets.chomp.downcase.start_with?("y")
  end

  def reset
    @deck = Deck.new
    @player.cards.clear
    @dealer.cards.clear
    clear_screen
  end
end

Game.new.start
