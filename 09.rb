#!/usr/bin/ruby

def find_low_points(points)
  low_points = []
  points.each_with_index do |row, i|
    row.each_with_index do |val, j|
      next if j > 0 && val >= points[i][j-1]
      next if j < row.length - 1 && val >= points[i][j+1]
      next if i > 0 && val >= points[i-1][j]
      next if i < points.length - 1 && val >= points[i+1][j]

      low_points << [i, j]
    end
  end
  low_points
end

def star_one(points)
  low_points = find_low_points(points)
  low_points.sum { |i, j| points[i][j] + 1}
end

def basin_size(points, x, y)
  size = 0
  visited = {}
  unvisited = [[x, y]]
  while unvisited.length > 0
    i, j = unvisited.pop
    next if visited["#{i}-#{j}"]
    val = points[i][j]
    size += 1
    visited["#{i}-#{j}"] = true
    unvisited << [i, j-1] if j > 0                    && val < points[i][j-1] && points[i][j-1] != 9
    unvisited << [i, j+1] if j < points[0].length - 1 && val < points[i][j+1] && points[i][j+1] != 9
    unvisited << [i-1, j] if i > 0                    && val < points[i-1][j] && points[i-1][j] != 9
    unvisited << [i+1, j] if i < points.length - 1    && val < points[i+1][j] && points[i+1][j] != 9
  end
  size
end

def star_two(points)
  low_points = find_low_points(points)
  basins = low_points.map { |i, j| basin_size(points, i, j) }
  basins.sort.last(3).inject(:*)
end

points = File.readlines("09_input.txt", chomp: true).map do |line|
  line.chars.map(&:to_i)
end

puts star_one(points)
puts star_two(points)
