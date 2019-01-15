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
    @strategy = nil # by default
    puts "at chessboard, #{EMPTY} means empty, #{BLACK} means ai player, #{WHITE} means human player"
  end

  def choose_strategy(strategy)
    @strategy = strategy.to_s
  end

  def player_fill(x, y)
    @chessboard[x][y] = WHITE
    self.print_board
  end

  def ai_play
    puts "ai playing"
    if self.strategy == 'random_walk'
      self.random_walk
    elsif self.strategy == 'minimax'
      self.minimax
    end
    self.print_board
  end

  def random_walk
    puts "random walk"
    empty_pos_list = [*0..(@board_x * @board_y - 1)].select do |num|
      x = num / board_y
      y = num % board_y
      @chessboard[x][y] = EMPTY
    end
    pos = empty_pos_list.sample
    @chessboard[pos / board_y][pos % board_y] = BLACK
  end

  def minimax
    puts "minimax"

  end

  def print_board
    @chessboard.each do |record|
      puts record.join(" ")
    end
  end



end
