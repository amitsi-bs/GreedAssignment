class DiceSet
  attr_reader :values

  # Roll `n` dice, return an array of ints 1..6
  def roll(n)
    @values = Array.new(n) { rand(1..6) }
  end
end
