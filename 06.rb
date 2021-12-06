#!/usr/bin/ruby

def spawns(map, days, state, current_day)
  key = "#{state}:#{current_day}"
  return map[key] if map[key]

  new_fish = 0
  current_day += state + 1
  while current_day <= days
    new_fish += 1
    new_fish += spawns(map, days, 8, current_day)
    current_day += 7
  end

  map[key]= new_fish
  new_fish
end

def calculate_fish(fish, days)
  fish_count = 0
  map = {}
  fish.each do |f|
    fish_count += 1
    fish_count += spawns(map, days, f, 0)
  end
  fish_count
end

def star_one(fish)
  calculate_fish(fish, 80)
end

def star_two(fish)
  calculate_fish(fish, 256)
end

fish = File.read("06_input.txt").chomp.split(",").map(&:to_i)

puts star_one(fish)
puts star_two(fish)
