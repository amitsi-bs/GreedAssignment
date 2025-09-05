require_relative '../game'

RSpec.describe Game do
  let(:game) { Game.new }

  describe "#setup_players" do
    it "creates the correct number of players" do
      allow(game).to receive(:gets).and_return("3")
      game.send(:setup_players)
      expect(game.instance_variable_get(:@players).size).to eq(3)
    end

    it "exits if input is 1" do
      allow(game).to receive(:gets).and_return("1")
      expect { game.send(:setup_players) }.to raise_error(SystemExit)
    end
    it "exits if input is 0" do
      allow(game).to receive(:gets).and_return("0")
      expect { game.send(:setup_players) }.to raise_error(SystemExit)
    end
  end

  describe "#handle_end_of_turn" do
    let(:player) { Player.new("Tester") }

    context "when player is already in game" do
      it "adds score to total" do
        player.in_game = true
        game.send(:handle_end_of_turn, player, 200)
        expect(player.total_score).to eq(200)
      end
    end

    context "when player is not in game" do
      it "enters the game if score >= MIN_ENTRY_SCORE" do
        game.send(:handle_end_of_turn, player, Game::MIN_ENTRY_SCORE)
        expect(player.in_game).to be true
        expect(player.total_score).to eq(Game::MIN_ENTRY_SCORE)
      end

      it "does not enter if score is too low" do
        game.send(:handle_end_of_turn, player, 100)
        expect(player.in_game).to be false
        expect(player.total_score).to eq(0)
      end
    end
  end

  describe "#ask_roll_again" do
    it "returns true if input is y" do
      allow(game).to receive(:gets).and_return("y\n")
      expect(game.send(:ask_roll_again, 3)).to be true
    end

    it "returns false if input is n" do
      allow(game).to receive(:gets).and_return("n\n")
      expect(game.send(:ask_roll_again, 3)).to be false
    end
  end
  describe "show_final_results" do
    it "identifies a tie correctly" do
      game.instance_variable_set(:@players, [Player.new("A"), Player.new("B")])
      game.instance_variable_get(:@players)[0].total_score = 1000
      game.instance_variable_get(:@players)[1].total_score = 1000
      expect { game.send(:show_final_results) }.to output(/It's a tie between: A, B/).to_stdout
    end

    it "identifies the winner correctly" do
      game.instance_variable_set(:@players, [Player.new("A"), Player.new("B")])
      game.instance_variable_get(:@players)[0].total_score = 2000
      game.instance_variable_get(:@players)[1].total_score = 1000
      expect { game.send(:show_final_results) }.to output(/Winner: A with 2000 points!/).to_stdout
    end
  end
end
