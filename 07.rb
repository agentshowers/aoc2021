#!/usr/bin/ruby

MAXINT = (2**(0.size * 8 -2) -1)


def best_position(crabs)
  min_fuel = MAXINT
  min_pos  = -1
  for i in crabs.min..crabs.max do
    fuel = crabs.sum { |crab| yield(crab, i) }
    if fuel < min_fuel
      min_fuel = fuel
      min_pos = i
    end
  end
  min_fuel
end

def star_one(crabs)
  best_position(crabs) do |crab, position|
    (crab - position).abs
  end
end

def star_two(crabs)
  best_position(crabs) do |crab, position|
    n = (crab - position).abs
    n * (n + 1) / 2
  end
end

crabs = File.read("07_input.txt").chomp.split(",").map(&:to_i)

puts star_one(crabs)
puts star_two(crabs)
