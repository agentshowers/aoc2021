#!/usr/bin/ruby

MAXINT = (2**(0.size * 8 -2) -1)

def neighbours(x, y, caves)
  neighbours = []
  neighbours << [x-1, y]   if x > 0
  neighbours << [x, y-1]   if y > 0
  neighbours << [x, y+1]   if y < caves.length - 1
  neighbours << [x+1, y]   if x < caves.length - 1
  neighbours
end

def shortest_path(caves)
  visited = Array.new(caves.length){Array.new(caves.length, false)}
  distances = Array.new(caves.length){Array.new(caves.length, MAXINT)}
  candidates = []
  distances[0][0] = 0
  next_cave = [0,0]
  while next_cave != [caves.length-1, caves.length-1]
    cave_x, cave_y = next_cave
    unless visited[cave_x][cave_y]
      visited[cave_x][cave_y] = true
      neighbours = neighbours(cave_x, cave_y, caves)
      neighbours.each do |i, j|
        next if visited[i][j]
        distance = distances[cave_x][cave_y] + caves[i][j]
        distances[i][j] = [distance, distances[i][j]].min
        insert_at = candidates.bsearch_index { |x, y| distances[x][y] < distances[i][j] } || 0
        candidates.insert(insert_at, [i, j])
      end
    end
    next_cave = candidates.pop
  end
  distances[next_cave[0]][next_cave[1]]
end

def star_one(caves)
  shortest_path(caves)
end

def star_two(caves)
  full_map = Array.new(caves.length * 5) { Array.new(caves.length * 5) }
  
  (0..caves.length - 1).each do |x|
    (0..caves.length - 1).each do |y|
      (0..4).each do |i|
        risk = caves[x][y] + i
        risk = risk > 9 ? risk - 9 : risk
        full_map[x][y + i * caves.length] = risk
      end
    end
  end

  (0..full_map.length - 1).each do |y|
    (0..caves.length - 1).each do |x|
      (1..4).each do |i|
        risk = full_map[x][y] + i
        risk = risk > 9 ? risk - 9 : risk
        full_map[x + i * caves.length][y] = risk
      end
    end
  end

  shortest_path(full_map)
end

caves = File.readlines("15_input.txt", chomp: true).map do |line|
  line.chars.map(&:to_i)
end

puts star_one(caves)
puts star_two(caves)
