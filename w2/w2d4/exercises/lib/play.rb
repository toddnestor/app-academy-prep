require_relative 'game'

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
  puts
  puts
  player
end

p1.attacking_board, p2.attacking_board = p2.board, p1.board
game = Game.new(p1, p2)
game.play
