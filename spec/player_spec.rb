require_relative '../player'

RSpec.describe Player do
  let(:player) { Player.new("Test Player") }

  it "initializes with a name" do
    expect(player.name).to eq("Test Player")
  end

  it "starts with a total score of 0" do
    expect(player.total_score).to eq(0)
  end

  it "starts with in_game set to false" do
    expect(player.in_game).to be false
  end

  it "allows updating total_score" do
    player.total_score = 150
    expect(player.total_score).to eq(150)
  end

  it "allows updating in_game status" do
    player.in_game = true
    expect(player.in_game).to be true
  end
end
