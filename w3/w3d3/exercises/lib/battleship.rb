require_relative 'helper'
require_relative 'position'
require_relative 'board'
require_relative 'player'
require_relative 'computer'
require_relative 'ship'

class BattleshipGame
  attr_reader :players, :turn

  def initialize(player_one, player_two)
    @players = [player_one, player_two]
    @turn = 0
  end

  def play
    BattleshipGame.instructions
    setup_boards

    until game_over?
      take_turn
    end

    winner = @players.select {|player| !player.board.won?}.first
    loser = @players.select {|player| player.board.won?}.first

    puts "Congratulations #{winner.name}, you won!"
    puts "Here was your final board:"
    winner.board.display(false)
    puts "And here was your opponent's:"
    loser.board.display(false)

    Helper.prompt("Press Enter to exit game.")
  end

  def game_over?
    @players.any? {|player| player.board.won?}
  end

  def take_turn
    current_player.take_turn
    swap_players
  end

  def current_player
    @players[@turn]
  end

  def other_player
    @players[not_turn]
  end

  def self.instructions
    puts
    puts "Battleship"
    puts
    puts "The goal is to sink all of the opponent's ships."
    puts "Each player first must place their ships on the board.  The other player can't watch while ships are being placed."
    puts "Players take turns firing at the opponents board."
    puts "To fire a shot you put in the grid coordinate for the spot you want to fire at."
    puts "The grid coordinate is made up of the letter for the horizontal position and the number for the vertical position."
    puts "You can see the letters across the top of the board and numbers along the left side of the board."
    puts "An example grid coordinate is B5"
    puts "If you hit a ship you will be notified of what type of ship you hit and it's length."
    puts "At the start of each turn you'll see an updated board that shows where you have fired."
    puts "A - indicates a spot you fired at and missed."
    puts "An X indicates a spot you fired at and hit."
    puts "When you have hit all the spots a ship is placed on you will be notified that you sunk the ship."
    puts "Good luck!"
    Helper.press_enter
  end

  def swap_players
    @turn = not_turn
  end

  def set_attacking_boards
    @players[0].attacking_board, @players[1].attacking_board = @players[1].board, @players[0].board
  end

  private
  def both_players_human?
    @players.all? {|player| player.instance_of?(HumanPlayer)}
  end

  def not_turn
    ( @turn + 1 ) % 2
  end

  def setup_boards
    @players.each do |player|
      if both_players_human?
        puts "\n" * 100
        puts "#{player.name}, you're up!  Time to place your ships."
        puts "Press Enter to start placing your ships.  Be sure not to let your opponent watch!"
        Helper.press_enter
      else
        puts "#{player.name}, you're up!  Time to place your ships."
        Helper.press_enter
      end

      player.place_ships
    end

    set_attacking_boards
  end
end

if __FILE__ == $PROGRAM_NAME
  def prompt( message )
    puts message
    gets.chomp
  end

  RANDOM_NAMES = [
    "Robo the robot",
    "Andy the android",
    "Zeke"
  ]

  def random_computer_name
    RANDOM_NAMES.shuffle!.pop
  end

  def set_up_player(num)
    type = nil
    until [1,2].include?(type)
      type = prompt("What type of player is player #{num}? Enter 1 for human, 2 for computer.").to_i
    end

    player = nil

    case type
    when 1 then player = HumanPlayer.new(prompt("What is player #{num}'s name?"))
    when 2 then player = ComputerPlayer.new(random_computer_name)
    end

    puts "Player #{num} is #{player.name}, good luck!"
    player
  end

  game = BattleshipGame.new(set_up_player("one"), set_up_player("two"))
  game.play
end
