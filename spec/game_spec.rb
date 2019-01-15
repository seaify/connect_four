# game_spec.rb
require './game'

RSpec.describe Game do

  describe "#strategy" do
    it "set strategy" do
      game = Game.new(3, 4, 3)
      game.choose_strategy('random_walk')
      expect(game.strategy).to eq('random_walk')
    end

    it "print board" do
      game = Game.new(3, 4, 3)
      game.print_board
    end

  end

end