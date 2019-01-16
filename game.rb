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
    self.strategy = strategy.to_s
  end

  def set_chessboard(chessboard)
    self.chessboard = chessboard
  end

  def player_fill(x, y)
    self.chessboard[x][y] = WHITE
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
    empty_pos_list = [*0..(self.board_x * self.board_y - 1)].select do |num|
      x = num / board_y
      y = num % board_y
      self.chessboard[x][y] == EMPTY
    end
    pos = empty_pos_list.sample
    self.chessboard[pos / board_y][pos % board_y] = BLACK
  end

  def minimax
    puts "minimax"

  end

  def print_board
    self.chessboard.each do |record|
      puts record.join(" ")
    end
  end

  def pos_legal?(x, y)
    return x >= 0 && x < self.board_x && y >= 0 && y < self.board_y
  end

  def pos_empty?(x, y)
    self.chessboard[x][y] == EMPTY
  end

  def have_winner(color)

    for i in 0..(board_x - 1)
      for j in 0..(board_y - 1)

        #row
        if j + win_count - 1 < board_y && self.chessboard[i][j..(j + win_count - 1)].uniq == [color]
          return true
        end

        #column
        if i + win_count - 1 < board_x
          column_elements =  [*0..(win_count - 1)].map {|offset| self.chessboard[i + offset][j]}
          return true if column_elements.uniq == [color]
        end

        #right up diagonal
        if i - win_count + 1 < board_x && j + win_count - 1 < board_y
          right_up_elements = [*0..(win_count - 1)].map {|offset| self.chessboard[i - offset][j + offset]}
          return true if right_up_elements.uniq == [color]
        end

        #right down diagonal
        if i + win_count - 1 < board_x && j + win_count - 1 < board_y
          right_down_elements = [*0..(win_count - 1)].map {|offset| self.chessboard[i + offset][j + offset]}
          return true if right_down_elements.uniq == [color]
        end
      end
    end

    return false
  end

  def end?
    if self.have_winner BLACK
      print "ai win!"
      return true
    end

    if self.have_winner WHITE
      print "you win!"
      return true
    end

    return false
  end



end

=begin
0 0 0 0 0
0 0 0 0 0
0 0 0 0 0
=end
