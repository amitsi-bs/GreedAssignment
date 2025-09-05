class Player
  attr_reader :name
  attr_accessor :total_score, :in_game

  def initialize(name)
    @name = name
    @total_score = 0
    @in_game = false
  end
end
