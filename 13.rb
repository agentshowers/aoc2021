#!/usr/bin/ruby

def fold(points, axis, line)
  pos = axis == "x" ? 0 : 1
  points.each do |p|
    p[pos] = line - (p[pos] - line) if p[pos] > line
  end
end

def star_one(points, folds)
  fold(points, folds[0][0], folds[0][1])
  points.uniq.count
end

def star_two(points, folds)
  folds.each { |axis, line| fold(points, axis, line) }
  max_x = points.map { |p| p[0] }.max
  max_y = points.map { |p| p[1] }.max
  print_map = Array.new(max_x + 1) { Array.new(max_y + 1) { "." }}
  points.each { |x, y| print_map[x][y] = "#" }
  i = 0
  while i <= max_y
    puts print_map.map { |l| l[i] }.join
    i += 1
  end
end

points = []
folds = []
lines = File.readlines("13_input.txt", chomp: true).each do |line|
  next if line == ""
  if /\d+,\d+/.match?(line)
    points << line.split(",").map(&:to_i)
  else
    /fold along (x|y)=(\d+)/ =~ line
    folds << [$1, $2.to_i]
  end
end

puts star_one(points, folds)
star_two(points, folds)

