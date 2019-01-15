require 'pry'

class Game

  EMPTY = 0
  BLACK = 1
  WHITE = 2

  attr_accessor :board_x, :board_y, :win_count, :chessboard, :strategy

  def initialize(board_x, board_y, win_count)
    @board_x = board_x
    @board_y = board_y
    @win_count = win_count
    @chessboard = Array.new(board_x) {Array.new(board_y, EMPTY)}
    @strategy = "random_walk" # by default
    puts "at chessboard, #{EMPTY} means empty, #{BLACK} means ai player, #{WHITE} means human player"
  end

  def choose_strategy(strategy)
    @strategy = strategy
  end

  def player_fill(x, y)
    @chessboard[x][y] = WHITE
    self.print_board
  end

  def ai_play
    puts "ai playing"
  end

  def random_walk

    binding.pry
    records = @strategy.flatten

  end

  def minimax

  end

  def print_board
    @chessboard.each do |record|
      puts record.join(" ")
    end
  end



end
