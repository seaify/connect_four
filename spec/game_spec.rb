# game_spec.rb
require './game'

RSpec.describe Game do

  describe "#strategy" do
    it "check score 2" do

      score1 = Game.evaluate_score [[1, 1, 0], [0, 2, 1],[2, 0, 0]], 3
      score2 = Game.evaluate_score [[0, 1, 1], [0, 2, 1],[2, 0, 0]], 3
      expect(score1).to be < score2

    end

    it "set strategy" do
      game = Game.new(3, 4, 3, 3)
      game.choose_strategy('random_walk')
      expect(game.strategy).to eq('random_walk')
    end

    it "check chessboard end?" do
      game = Game.new(3, 3, 3, 3)
      game.set_chessboard [[1, 2, 1], [0, 2, 0],[1, 2, 0]]
      #expect(game.end?).to eq(true)
    end

    it "check score" do

      score1 = Game.evaluate_score [[1, 1, 1], [0, 2, 0],[2, 2, 0]], 3
      score2 = Game.evaluate_score [[1, 1, 0], [0, 2, 0],[2, 2, 1]], 3

      expect(score1).to be > score2

    end


    it "choose center" do

      score1 = Game.evaluate_score [[0, 0, 1], [0, 1, 0],[0, 0, 0]], 3
      score2 = Game.evaluate_score [[1, 0, 0], [0, 0, 0],[0, 0, 0]], 3

      expect(score1).to be > score2

    end

    it "sort alternative nodes" do

      game = Game.new(4, 4, 3, 2)
      game.set_chessboard [[0, 0, 0, 1], [2, 0, 2, 1],[0, 0, 0, 0], [0, 0 , 0,  0]]

      points = Game.sorted_pos_list(game.chessboard, Game::BLACK)
      zero_point_index = points.find_index {|x| x[0] + x[1] == 0}

      expect(zero_point_index).to be > 0 # 0, 0 shouldn't list at first place

    end

  end


end