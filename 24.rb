#!/usr/bin/ruby

instructions = File.readlines("24_input.txt", chomp: true).map{ |line| line.split(" ") }
a = []
b = []
c = []
instructions.each_slice(18) do |slice|
  a << slice[4][2].to_i
  b << slice[5][2].to_i
  c << slice[15][2].to_i
end

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
