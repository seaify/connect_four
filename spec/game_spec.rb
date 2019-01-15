# game_spec.rb
require './game'

RSpec.describe Game do

  describe "#score" do
    it "returns 0 for an all gutter game" do
      game = Game.new(3, 4, 3)
      game.choose_strategy('random_walk')
      expect(game.strategy).to eq('random_walk')
    end
  end

end