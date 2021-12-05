#!/usr/bin/ruby

MAX = 1000

def move_x(map, x1, x2, y)
  count = 0 
  for i in [x1, x2].min..[x1, x2].max do
    map[i][y] += 1
    count += 1 if map[i][y] == 2
    i += 1
  end
  count
end

def move_y(map, x, y1, y2)
  count = 0
  for j in [y1, y2].min..[y1, y2].max do
    map[x][j] += 1
    count += 1 if map[x][j] == 2
    j += 1
  end
  count
end

def move_diagonal(map, x1, x2, y1, y2)
  i = x1
  j = y1
  x_direction = x1 < x2 ? 1 : -1
  y_direction = y1 < y2 ? 1 : -1
  count = 0

  loop do
    map[i][j] += 1
    count += 1 if map[i][j] == 2
    break if i == x2
    i += x_direction
    j += y_direction
  end

  count
end

def star_one(fields)
  map = Array.new(MAX){Array.new(MAX, 0)}
  count = 0
  fields.each do |origin, destination|
    if origin[0] != destination[0]
      next if origin[1] != destination[1]
      count += move_x(map, origin[0], destination[0], origin[1])
    else
      count += move_y(map, origin[0], origin[1], destination[1])
    end
  end
  count
end

def star_two(fields)
  map = Array.new(MAX){Array.new(MAX, 0)}
  count = 0
  fields.each do |origin, destination|
    if origin[0] != destination[0]
      if origin[1] != destination[1]
        count += move_diagonal(map, origin[0], destination[0], origin[1], destination[1])
      else
        count += move_x(map, origin[0], destination[0], origin[1])
      end
    else
      count += move_y(map, origin[0], origin[1], destination[1])
    end
  end
  count
end

fields = File.readlines("05_input.txt", chomp: true).map do |line|
  origin, destination = line.split(" -> ")
  [origin.split(",").map(&:to_i), destination.split(",").map(&:to_i)]
end

puts star_one(fields)
puts star_two(fields)
