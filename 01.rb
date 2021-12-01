#!/usr/bin/ruby

def star_one(depths)
  increases = 0
  i = 1
  while i < depths.length
    increases += 1 if depths[i] > depths[i-1]
    i += 1
  end
  increases
end

def star_two(depths)
  increases = 0
  i = 3
  while i < depths.length
    increases += 1 if depths[i] > depths[i-3]
    i += 1
  end
  increases
end

depths = File.readlines("01_input.txt", chomp: true).map(&:to_i)
puts star_one(depths)
puts star_two(depths)