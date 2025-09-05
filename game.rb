require_relative 'player'
require_relative 'dice_set'
require_relative 'greed_score'

class Game
  MIN_ENTRY_SCORE = 300
  END_GAME_SCORE   = 3000
  DICE_COUNT       = 5

  def initialize
    @players = []
    @dice_set = DiceSet.new
  end

  def start
    setup_players
    play_until_final_round
  end

  private

  def setup_players
    print "Enter number of players: "
    num = gets.to_i
    if num == 0
      puts "Game cannot be played with 0 players."
      exit
    elsif num == 1
      puts "You are the only person in the game, so cannot move forward."
      exit
    end
    (1..num).each { |i| @players << Player.new("Player #{i}") }
  end

  def play_until_final_round
    puts "\nStarting game with #{@players.size} players.\n\n"

    @players.each_with_index do |player, idx|
      # standard round-by-round play until someone triggers final
      turn_score = player_turn(player)
      handle_end_of_turn(player, turn_score)
      if player.total_score >= END_GAME_SCORE
        puts "\n--- Final Round Triggered by #{player.name} (#{player.total_score}) ---"
        do_final_round(trigger_index: idx)
        show_final_results
        return
      end
    end

    # keep looping rounds until someone triggers final
    loop do
      @players.each_with_index do |player, idx|
        turn_score = player_turn(player)
        handle_end_of_turn(player, turn_score)
        if player.total_score >= END_GAME_SCORE
          puts "\n--- Final Round Triggered by #{player.name} (#{player.total_score}) ---"
          do_final_round(trigger_index: idx)
          show_final_results
          return
        end
      end
    end
  end

  def player_turn(player)
    puts "\nTurn for #{player.name}:"
    turn_total = 0
    dice_to_roll = DICE_COUNT

    loop do
      roll = @dice_set.roll(dice_to_roll)
      roll_score, scoring_dice = score(roll)

      puts "Roll: #{roll.join(', ')}"
      puts "Score in this roll: #{roll_score}"

      if roll_score == 0
        puts "Bust! You lose all points for this turn."
        return 0
      end

      turn_total += roll_score
      dice_to_roll -= scoring_dice.size
      dice_to_roll = DICE_COUNT if dice_to_roll == 0 # hot dice — roll all again

      puts "Total score in this turn so far: #{turn_total}"

      # Ask player whether to roll remaining dice
      break unless ask_roll_again(dice_to_roll)
    end

    turn_total
  end

  def ask_roll_again(remaining_dice)
    print "Roll the non-scoring #{remaining_dice} dice? (y/n): "
    ans = gets.strip.downcase
    ans == 'y'
  end

  def handle_end_of_turn(player, turn_score)
    if player.in_game
      # already qualified — always add turn_score
      player.total_score += turn_score
      puts "Added #{turn_score} to #{player.name}'s total."
    else
      # not in game yet — need MIN_ENTRY_SCORE in a single turn to enter
      if turn_score >= MIN_ENTRY_SCORE
        player.in_game = true
        player.total_score += turn_score
        puts "#{player.name} has entered the game with #{turn_score} points!"
      else
        puts "#{player.name} did not reach #{MIN_ENTRY_SCORE} this turn. No points added."
      end
    end

    puts "Total score: #{player.total_score}"
  end

  def do_final_round(trigger_index:)
    # Each other player gets one more turn (starting with next player)
    n = @players.size
    order = (1...n).map { |i| (trigger_index + i) % n }
    @final_round_scores=[]
    order.each do |player_idx|
      player = @players[player_idx]
      puts "\nFinal round: #{player.name}'s last turn:"
      turn_score = player_turn(player)
      handle_end_of_turn(player, turn_score)
      @final_round_scores << turn_score
    end
    if @final_round_scores.all? { |score| score == 0 }
      puts "\nAll players busted in the final round. No additional points were scored."
    end
  end

  def show_final_results
    puts "\n--- Final Scores ---"
    @players.each { |p| puts "#{p.name}: #{p.total_score}" }
    max_score = @players.map(&:total_score).max
    winners = @players.select { |p| p.total_score == max_score }
    if winners.size > 1
      puts "\nIt's a tie between: #{winners.map(&:name).join(', ')} with #{max_score} points!"
    else
      puts "\nWinner: #{winners.first.name} with #{max_score} points!"
    end
  end
end

if __FILE__ == $0
  Game.new.start
end
