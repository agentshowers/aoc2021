#!/usr/bin/ruby

def star_one(instructions)
  horizontal = 0
  depth = 0

  instructions.each do |i|
    case i[0]
    when "down"
      depth += i[1]
    when "up"
      depth -= i[1]
    when "forward"
      horizontal += i[1]
    end
  end

  horizontal * depth
end

def star_two(instructions)
  horizontal = 0
  depth = 0
  aim = 0

  instructions.each do |i|
    case i[0]
    when "down"
      aim += i[1]
    when "up"
      aim -= i[1]
    when "forward"
      horizontal += i[1]
      depth += aim * i[1]
    end
  end

  horizontal * depth
end

instructions = File.readlines("02_input.txt", chomp: true).map do |line|
  a, b = line.split(" ")
  [a, b.to_i]
end
puts star_one(instructions)
puts star_two(instructions)
