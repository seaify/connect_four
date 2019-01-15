require './game'
require 'highline'

game = Game.new(3,3, 3)

cli = HighLine.new
strategy = cli.choose do |menu|
  menu.prompt = "Please choose one strategy "
  menu.choice(:random_walk)
  menu.choices(:minimax)
  menu.default = :random_walk
end

puts strategy
game.choose_strategy(strategy)


while true

  game.print_board
  answer = cli.ask "your turn, input chess position(like  1 1): "

  puts answer
  x, y = answer.split(" ")
  game.player_fill x.to_i - 1, y.to_i - 1

  game.ai_play

  break

end