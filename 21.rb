#!/usr/bin/ruby

def add_roll(p1, p2, p1_points, p2_points, next_p, roll)
  p1 = (p1 + roll * (1 - next_p)) % 10
  p1_points += (1 - next_p) * (p1 + 1)
  p2 = (p2 + roll * next_p) % 10
  p2_points += next_p * (p2 + 1)
  [p1, p2, p1_points, p2_points]
end

def play_one(p1, p2, p1_points, p2_points, next_p)
  rolls = 0
  next_roll = 1

  while p1_points < 1000 && p2_points < 1000
    roll_sum = (next_roll..next_roll+2).sum { |r| r % 100}
    next_roll = (next_roll + 3) % 100
    rolls += 3
    p1, p2, p1_points, p2_points = add_roll(p1, p2, p1_points, p2_points, next_p, roll_sum)
    next_p = 1 - next_p
  end

  rolls * [p1_points, p2_points].min
end

def star_one(p1, p2)
  play_one(p1-1, p2-1, 0, 0, 0)
end

POSSIBLE_ROLLS = {
  3 => 1,
  4 => 3,
  5 => 6,
  6 => 7,
  7 => 6,
  8 => 3,
  9 => 1
}

def play_two(p1, p2, p1_points, p2_points, next_p, map)
  key = [p1, p2, p1_points, p2_points, next_p]
  return map[key] if map[key]

  if p1_points >= 21
    wins = [1, 0]
  elsif p2_points >= 21
    wins = [0, 1]
  else
    wins = POSSIBLE_ROLLS.map do |roll, count|
      xp1, xp2, xp1_points, xp2_points = add_roll(p1, p2, p1_points, p2_points, next_p, roll)
      p1_wins, p2_wins = play_two(xp1, xp2, xp1_points, xp2_points, 1 - next_p, map)
      [p1_wins * count, p2_wins * count]
    end.transpose.map(&:sum)
  end

  map[key] = wins
  wins
end

def star_two(p1, p2)
  wins = play_two(p1 - 1, p2 - 1, 0, 0, 0, {})
  wins.max
end

p1, p2 = File.readlines("21_input.txt", chomp: true).map do |line|
  /Player \d starting position: (\d)/ =~ line
  $1.to_i
end

puts star_one(p1, p2)
puts star_two(p1, p2)