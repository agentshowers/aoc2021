#!/usr/bin/ruby

instructions = File.readlines("24_input.txt", chomp: true).map{ |line| line.split(" ") }
a = (0..13).to_a.map { |i| instructions[i*18 + 4][2].to_i }
b = (0..13).to_a.map { |i| instructions[i*18 + 5][2].to_i }
c = (0..13).to_a.map { |i| instructions[i*18 + 15][2].to_i }

min = Array.new(14)
max = Array.new(14)

stack = []
a.each_with_index do |val, idx|
  if val == 1
    stack.push(idx)
  else
    p_idx = stack.pop
    val = c[p_idx] + b[idx]
    min[p_idx] = [1, -val + 1].max
    min[idx] = min[p_idx] + val
    max[p_idx] = [9, 9-val].min
    max[idx] = max[p_idx] + val
  end
end

puts "Star one: #{max.join}"
puts "Star two: #{min.join}"
