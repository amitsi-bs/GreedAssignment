require_relative '../dice_set'

RSpec.describe DiceSet do
  let(:dice_set) { DiceSet.new }

  describe "#roll" do
    it "returns an array of integers" do
      result = dice_set.roll(5)
      expect(result).to all(be_a(Integer))
    end

    it "returns values between 1 and 6" do
      result = dice_set.roll(10)
      expect(result).to all(be_between(1, 6))
    end

    it "returns exactly n values" do
      expect(dice_set.roll(3).size).to eq(3)
    end

    it "sets @values to the roll result" do
      roll_result = dice_set.roll(4)
      expect(dice_set.values).to eq(roll_result)
    end
  end
end
