class Game

  attr_accessor :board_x, :board_y, :win_count, :chessboard, :strategy

  def initialize(board_x, board_y, win_count)
    @board_x = board_x
    @board_y = board_y
    @win_count = win_count
    @chessboard = [[0] * board_x] * board_y
    @strategy = "random_walk" # by default
  end

  def choose_strategy(strategy)
    @strategy = strategy
  end

  def random_walk


  end

  def minimax

  end



end
