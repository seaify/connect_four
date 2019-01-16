require 'pry'

class Game

  EMPTY = 0
  BLACK = 1
  WHITE = 2
  INF = 10000

  attr_accessor :board_x, :board_y, :win_count, :chessboard, :strategy, :ai_depth

  def initialize(board_x, board_y, win_count)
    @board_x = board_x
    @board_y = board_y
    @win_count = win_count
    @chessboard = Array.new(board_x) {Array.new(board_y, EMPTY)}
    @strategy = nil # by default
    @ai_depth = 3
    puts "at chessboard, #{EMPTY} means empty, #{BLACK} means ai player, #{WHITE} means human player"
  end

  class << self

    def have_winner?(chessboard, color, win_count)
      board_x = chessboard.count
      board_y = chessboard[0].count
      for i in 0..(board_x - 1)
        for j in 0..(board_y - 1)

          #row
          if j + win_count - 1 < board_y && chessboard[i][j..(j + win_count - 1)].uniq == [color]
            return true
          end

          #column
          if i + win_count - 1 < board_x
            column_elements =  [*0..(win_count - 1)].map {|offset| chessboard[i + offset][j]}
            return true if column_elements.uniq == [color]
          end

          #right up diagonal
          if i - win_count + 1 < board_x && j + win_count - 1 < board_y
            right_up_elements = [*0..(win_count - 1)].map {|offset| chessboard[i - offset][j + offset]}
            return true if right_up_elements.uniq == [color]
          end

          #right down diagonal
          if i + win_count - 1 < board_x && j + win_count - 1 < board_y
            right_down_elements = [*0..(win_count - 1)].map {|offset| chessboard[i + offset][j + offset]}
            return true if right_down_elements.uniq == [color]
          end
        end
      end

      return false
    end

    def evaluate_score(chessboard, win_count)

      if Game.have_winner? chessboard, BLACK, win_count
        return INF
      end

      return 0
    end

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
      self.minimax_walk
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

  def minimax_walk
=begin
    empty_pos_list = [*0..(self.board_x * self.board_y - 1)].select do |num|
      x = num / board_y
      y = num % board_y
      self.chessboard[x][y] == EMPTY
    end
    final_score = INF
    final_pos = -1
    empty_pos_list.each do |pos|

      x = pos / board_y
      y = pos % board_y

      self.chessboard[x][y] = BLACK

      score = self.minimax(self.chessboard, self.ai_depth, WHITE)
      if score < final_score
        final_score = score
        final_pos = pos
        puts "pos #{x} #{y}, score is #{score}"
      end

      self.chessboard[x][y] = EMPTY
    end

=end
    #self.chessboard[final_pos / board_y][final_pos % board_y] = BLACK
    score, steps = self.minimax self.chessboard, self.ai_depth, BLACK, []
    puts "score is #{score}, steps is #{steps}"
    self.chessboard[steps[0][0]][steps[0][1]] = BLACK
  end

  def minimax(board, depth, color, steps)
    if depth == 0
      return Game.evaluate_score(board, self.win_count), steps
    end

    if color == BLACK
      value = -INF
      final_steps = []
      for i in 0..(self.board_x - 1)
        for j in 0..(self.board_y - 1)
          if board[i][j] == EMPTY
            board[i][j] = BLACK
            score, steps = self.minimax(board, depth - 1, WHITE, steps + [[i, j]])
            if score > value
              value = score
              final_steps = [[i, j]] + steps
            end
            board[i][j] = EMPTY
          end
        end
      end

      return value, final_steps
    end

    if color == WHITE
      value = INF
      final_steps = []
      for i in 0..(self.board_x - 1)
        for j in 0..(self.board_y - 1)
          if board[i][j] == EMPTY
            board[i][j] = WHITE
            score, steps = self.minimax(board, depth - 1, BLACK, steps + [[i, j]])
            if score < value
              value = score
              final_steps = [[i, j]] + steps
            end
            board[i][j] = EMPTY
          end
        end
      end
      return value, final_steps

    end

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

  def have_winner?(color)
    Game.have_winner? self.chessboard, color, self.win_count
  end

  def end?
    if self.have_winner? BLACK
      print "ai win!"
      return true
    end

    if self.have_winner? WHITE
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
