require 'pry'

class Game

  EMPTY = 0
  BLACK = 1
  WHITE = 2
  INF = 100000000

  attr_accessor :board_x, :board_y, :win_count, :chessboard, :strategy, :ai_depth, :just_start

  def initialize(board_x, board_y, win_count, ai_depth)
    @board_x = board_x
    @board_y = board_y
    @win_count = win_count
    @chessboard = Array.new(board_x) {Array.new(board_y, EMPTY)}
    @strategy = nil # by default
    @ai_depth = ai_depth
    @just_start = true
    puts "at chessboard, #{EMPTY} means empty, #{BLACK} means ai player, #{WHITE} means human player"
  end

  class << self


    def sorted_pos_list(board, color)
      board_x = board.count
      board_y = board[0].count
      result = []
      for i in 0..(board_x - 1 )
        for j in 0..(board_y - 1 )

          if board[i][j] == EMPTY
            points = [element(board, i - 1, j - 1), element(board, i - 1, j), element(board, i - 1, j + 1),
                      element(board, i, j - 1), element(board, i, j + 1),
                      element(board, i + 1, j - 1), element(board, i + 1, j), element(board, i + 1, j + 1),
            ]
            same_count = points.flatten.select {|x| x == color}.count
            result.push [[i, j], same_count]
          end
        end
      end
      result.sort! { |x,y| y[1] <=> x[1] }
      result.map {|x| x[0]}

    end

    def consecutive_count(chessboard, color, win_count, return_if_find = false)
      total = 0
      board_x = chessboard.count
      board_y = chessboard[0].count
      for i in 0..(board_x - 1)
        for j in 0..(board_y - 1)

          return total if return_if_find && total > 0 # quick return when detect game end

          #row
          if j + win_count - 1 < board_y && chessboard[i][j..(j + win_count - 1)] == [color] * win_count
            total += 1
          end

          #column
          if i + win_count - 1 < board_x
            column_elements =  [*0..(win_count - 1)].map {|offset| chessboard[i + offset][j]}
            total += 1 if column_elements == [color] * win_count
          end

          #right up diagonal
          if i - win_count + 1 < board_x && j + win_count - 1 < board_y
            right_up_elements = [*0..(win_count - 1)].map {|offset| chessboard[i - offset][j + offset]}
            total += 1 if right_up_elements == [color] * win_count
          end

          #right down diagonal
          if i + win_count - 1 < board_x && j + win_count - 1 < board_y
            right_down_elements = [*0..(win_count - 1)].map {|offset| chessboard[i + offset][j + offset]}
            total += 1 if right_down_elements == [color] * win_count
          end

        end
      end

      return total
    end

    def get_endpoint_score(both_ends, win_count)
      if both_ends == [EMPTY, EMPTY]
        10 ** win_count
      elsif both_ends == [EMPTY]
        (10 ** win_count) / 4
      else
        0
      end
    end

    def element(board, x, y)
      if x >= 0 && x < board.count && y >= 0 && y < board[0].count
        return board[x][y]
      end
      return nil
    end

    def get_score(chessboard, color, win_count, total_size)
      if win_count == total_size && Game.consecutive_count(chessboard, color, total_size, true) >= 1
        return INF
      end

      total_score = 0
      board_x = chessboard.count
      board_y = chessboard[0].count
      for i in 0..(board_x - 1)
        for j in 0..(board_y - 1)

          #row
          if j + win_count - 1 < board_y && chessboard[i][j..(j + win_count - 1)] == [color] * win_count
            #both_ends open
            both_ends = [element(chessboard,i, j - 1), element(chessboard, i, j + win_count)].reject {|x| x.nil?}
            total_score += Game.get_endpoint_score both_ends, win_count
          end

          #column
          if i + win_count - 1 < board_x
            column_elements =  [*0..(win_count - 1)].map {|offset| chessboard[i + offset][j]}
            if column_elements == [color] * win_count
              both_ends = [element(chessboard, i - 1, j), element(chessboard, i + win_count, j)].reject {|x| x.nil?}
              total_score += Game.get_endpoint_score both_ends, win_count
            end
          end

          #right up diagonal
          if i - win_count + 1 < board_x && j + win_count - 1 < board_y
            right_up_elements = [*0..(win_count - 1)].map {|offset| chessboard[i - offset][j + offset]}
            if right_up_elements == [color] * win_count
              both_ends = [element(chessboard, i + 1, j - 1), element(chessboard, i - win_count, j + win_count)].reject {|x| x.nil?}
              total_score += Game.get_endpoint_score both_ends, win_count
            end
          end

          #right down diagonal
          if i + win_count - 1 < board_x && j + win_count - 1 < board_y
            right_down_elements = [*0..(win_count - 1)].map {|offset| chessboard[i + offset][j + offset]}
            if right_down_elements == [color] * win_count
              both_ends = [element(chessboard, i - 1, j - 1), element(chessboard, i + win_count, j + win_count)].reject {|x| x.nil?}
              total_score += Game.get_endpoint_score both_ends, win_count
            end
          end

        end
      end

      return total_score
    end



    def evaluate_score(chessboard, win_count)
      #binding.pry

      score = self.evaluate_color_score(chessboard, BLACK, win_count) - self.evaluate_color_score(chessboard, WHITE, win_count)
      return score
    end

    def evaluate_color_score(chessboard, color, win_count)

      score = 0

      #special situation, first point, always choose center
      if chessboard.flatten.select {|x| x == color }.count == 1 && chessboard.flatten.uniq.count == 2

        pos = chessboard.flatten.find_index {|x| x == color }

        board_x = chessboard.count
        board_y = chessboard[0].count
        x = pos / board_y
        y = pos % board_y
        avg = (board_y + board_x) / 2
        score = (x + y - avg).abs + (x - y).abs
        return -score;
      else


        for num in (1..win_count)
          #binding.pry
          if color == BLACK
            score += Game.get_score(chessboard, color, num, win_count) * (10 ** num)
          else
            #human
            score += Game.get_score(chessboard, color, num, win_count) * (10 ** (num + 1))
          end
        end


      end


      return score
    end

  end

  def element(x, y)
    if pos_legal?(x, y)
      return self.chessboard[x][y]
    end
    return nil
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
    if self.just_start
      score, steps = self.minimax self.chessboard.dup, 1, BLACK, -INF, INF, []
      self.just_start = false
    else
      score, steps = self.minimax self.chessboard.dup, self.ai_depth, BLACK, -INF, INF, []
    end
    puts "\n"
    puts "final result score: #{score}, steps #{steps}"

    self.chessboard[steps[0][0]][steps[0][1]] = BLACK
  end

  def minimax(board, depth, color, alpha, beta, steps)
    if depth == 0 || self.end?
      return Game.evaluate_score(board, self.win_count), steps
    end

    if color == BLACK
      value = -INF
      final_steps = []
      #have bug
      Game.sorted_pos_list(board, BLACK).each do |pos|
        i, j = pos
        if board[i][j] == EMPTY
            board[i][j] = BLACK
            score, current_steps = self.minimax(board, depth - 1, WHITE, alpha, beta, steps.dup.push([i, j]))
            if score > value
              value = score
              final_steps = current_steps.dup
            end
            puts "current i = #{i}, j = #{j}, board = #{board}, score=#{score} #{current_steps}" #if depth == self.ai_depth
            board[i][j] = EMPTY
            alpha = [alpha, score].max
            if alpha >= beta
              return value, final_steps
            end
         end
      end

      return value, final_steps
    end

    if color == WHITE
      value = INF
      final_steps = []

      Game.sorted_pos_list(board, WHITE).each do |pos|
        i, j = pos
        if board[i][j] == EMPTY
          board[i][j] = WHITE
          #puts "current i = #{i}, j = #{j}, board = #{board}, steps=#{steps}"
          score, current_steps = self.minimax(board, depth - 1, BLACK, alpha, beta, steps.dup.push([i, j]) )
          if score < value
            value = score
            final_steps = current_steps.dup
          end
          board[i][j] = EMPTY
          beta = [beta, score].min
          if beta <= alpha
            return value, final_steps
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
    Game.consecutive_count(self.chessboard, color, self.win_count, true) >= 1
  end

  def end?
    if self.have_winner? BLACK
      return true
    end

    if self.have_winner? WHITE
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

