#!/usr/bin/ruby

def star_one(min_x, max_x, min_y, max_y)
  y_velocity = min_y.abs - 1
  y_velocity*(y_velocity + 1)/2
end

def lands(x_speed, y_speed, min_x, max_x, min_y, max_y)
  x, y = 0, 0
  loop do
    x += x_speed
    y += y_speed
    x_speed = [0, x_speed-1].max
    y_speed -= 1
    return true if x.between?(min_x, max_x) && y.between?(min_y, max_y)
    return false if x > max_x || y < min_y
  end
end

def star_two(min_x, max_x, min_y, max_y)
  y_range = (min_y..min_y.abs - 1).to_a
  x_range = (((1 + Math.sqrt(1 + 8*min_x))/2).floor..max_x).to_a

  count = 0
  for x in x_range do
    for y in y_range do
      count += 1 if lands(x, y, min_x, max_x, min_y, max_y)
    end
  end
  count
end

input = File.read("17_input.txt").chomp

/target area: x=([\d-]+)..([\d-]+), y=([\d-]+)..([\d-]+)/ =~ input
min_x = $1.to_i
max_x = $2.to_i
min_y = $3.to_i
max_y = $4.to_i

puts star_one(min_x, max_x, min_y, max_y)
puts star_two(min_x, max_x, min_y, max_y)
