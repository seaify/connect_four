# game_spec.rb
require './game'

RSpec.describe Game do

  describe "#strategy" do
    it "set strategy" do
      game = Game.new(3, 4, 3)
      game.choose_strategy('random_walk')
      expect(game.strategy).to eq('random_walk')
    end

    it "set chessboard" do
      game = Game.new(3, 3, 3)
      game.set_chessboard [[1, 2, 1], [0, 2, 0],[1, 2, 0]]
      expect(game.end?).to eq(true)
    end

  end

end