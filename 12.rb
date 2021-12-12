#!/usr/bin/ruby

def build_map(links)
  map = {}
  links.each do |a, b|
    map[a] = (map[a] || []) << b
    map[b] = (map[b] || []) << a
  end
  map
end

def paths(map, cave, visited, allow_2nd_visit)
  return 0 if visited[cave] == 1 && (!allow_2nd_visit || cave == "start")
  return 0 if visited[cave] == 2
  return 1 if cave == "end"

  if cave == cave.downcase
    visited = visited.dup
    visited[cave] = (visited[cave] || 0) + 1
    allow_2nd_visit = allow_2nd_visit && visited[cave] == 1
  end

  paths = map[cave].sum { |c| paths(map, c, visited, allow_2nd_visit) }
  paths
end

def star_one(map)
  visited = {}
  paths(map, "start", visited, false)
end

def star_two(map)
  visited = {}
  paths(map, "start", visited, true)
end

links = File.readlines("12_input.txt", chomp: true).map do |line|
  line.split("-")
end

map = build_map(links)

puts star_one(map)
puts star_two(map)

