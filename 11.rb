#!/usr/bin/ruby

def neighbours(x, y, octopi)
  neighbours = []
  neighbours << [x-1, y-1] if x > 0 && y > 0
  neighbours << [x-1, y]   if x > 0
  neighbours << [x-1, y+1] if x > 0 && y < octopi.length - 1
  neighbours << [x, y-1]   if y > 0
  neighbours << [x, y+1]   if y < octopi.length - 1
  neighbours << [x+1, y-1] if x < octopi.length - 1 && y > 0
  neighbours << [x+1, y]   if x < octopi.length - 1
  neighbours << [x+1, y+1] if x < octopi.length - 1 && y < octopi.length - 1
  neighbours
end

def step(octopi)
  flashable = []
  has_flashed = {}
  flashes = 0

  octopi.each_with_index do |row, x|
    row.each_with_index do |energy, y|
      octopi[x][y] = energy + 1
      flashable << [x,y] if octopi[x][y] > 9
    end
  end

  while flashable.length > 0
    x, y = flashable.pop
    next if has_flashed["#{x}-#{y}"]
    flashes += 1
    has_flashed["#{x}-#{y}"] = true
    octopi[x][y] = 0
    neighbours(x, y, octopi).each do |nx, ny|
      next if has_flashed["#{nx}-#{ny}"]
      octopi[nx][ny] += 1
      flashable << [nx, ny] if octopi[nx][ny] > 9
    end
  end

  flashes

end

def star_one(octopi)
  sum = 0
  (1..100).each do |_|
    sum += step(octopi)
  end
  sum
end

def star_two(octopi)
  i = 1
  loop do
    flashes = step(octopi)
    return i if flashes == (octopi.length * octopi.length)
    i += 1
  end
end

octopi = File.readlines("11_input.txt", chomp: true).map do |line|
  line.chars.map(&:to_i)
end

puts star_one(octopi)

octopi = File.readlines("11_input.txt", chomp: true).map do |line|
  line.chars.map(&:to_i)
end

puts star_two(octopi)
