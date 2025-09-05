# Returns [points, scoring_dice_array]
def score(dice)
  counts = Hash.new(0)
  dice.each { |d| counts[d] += 1 }

  total = 0
  scoring = []

  (1..6).each do |num|
    cnt = counts[num] || 0

    # Triples
    if cnt >= 3
      if num == 1
        total += 1000
      else
        total += num * 100
      end
      scoring.concat([num] * 3)
      cnt -= 3
    end

    # Remaining singles: only 1s and 5s score
    if num == 1 && cnt > 0
      total += cnt * 100
      scoring.concat([1] * cnt)
    elsif num == 5 && cnt > 0
      total += cnt * 50
      scoring.concat([5] * cnt)
    end
  end

  [total, scoring]
end
