require './game'
require 'highline'

game = Game.new(6 ,7, 4, 2)

cli = HighLine.new
strategy = cli.choose do |menu|
  menu.prompt = "Please choose one strategy "
  menu.choice(:random_walk)
  menu.choices(:minimax)
  menu.default = :random_walk
end

puts strategy
game.choose_strategy(strategy)

=begin
game.set_chessboard(
[[0, 1, 0],
[0, 2, 1],
[2, 0, 0]])
=end

game.set_chessboard(
      [[0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0],
[0, 0, 2, 0, 0, 0, 0],
[0, 2, 1, 1, 1, 2, 0],
[0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0]]
)

while true

  game.ai_play

  if game.end?
    puts "ai win"
    break
  end

  while true
    answer = cli.ask "your turn, input chess position(like  1 1): "

    puts answer
    x, y = answer.split(" ")
    x = x.to_i - 1
    y = y.to_i - 1

    if game.pos_legal?(x, y) && game.pos_empty?(x, y)
      game.player_fill x, y
      break
    else
      puts "post not legal or filled"
    end

  end

  if game.end?
    puts "you win"
    break
  end


end