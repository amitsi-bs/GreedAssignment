require_relative '../greed_score'

RSpec.describe "#score" do
  it "returns [0, []] for no scoring dice" do
    expect(score([2, 3, 4, 6, 2])).to eq([0, []])
  end

  it "scores single 1 as 100" do
    expect(score([1, 2, 3, 4, 6])).to eq([100, [1]])
  end

  it "scores single 5 as 50" do
    expect(score([5, 2, 3, 4, 6])).to eq([50, [5]])
  end

  it "scores triple 1s as 1000" do
    expect(score([1, 1, 1, 2, 3])).to eq([1000, [1, 1, 1]])
  end

  it "scores triple 5s as 500" do
    expect(score([5, 5, 5, 2, 3])).to eq([500, [5, 5, 5]])
  end

  it "scores triple of other numbers correctly" do
    expect(score([2, 2, 2, 3, 4])).to eq([200, [2, 2, 2]])
  end

  it "adds extra single 1s after triples" do
    expect(score([1, 1, 1, 1, 2])).to eq([1100, [1, 1, 1, 1]])
  end

  it 'calculates triple 1s and single 5 correctly' do
    expect(score([1,1,1,5,2])).to eq([1050, [1, 1, 1, 5]])
  end

  it "adds extra single 5s after triples" do
    expect(score([5, 5, 5, 5, 6])).to eq([550, [5, 5, 5, 5]])
  end
end
