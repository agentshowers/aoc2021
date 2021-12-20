#!/usr/bin/ruby

def pad(image, char)
  new_line = [char] * image.length
  image.insert(0, new_line.dup)
  image.insert(0, new_line.dup)
  image.push(new_line.dup)
  image.push(new_line.dup)
  image.map! { |l| "#{char}#{char}#{l.join}#{char}#{char}".chars }
end

def position(image, i_range, j_range)
  code = []
  for i in i_range
    for j in j_range
      i = [0, i].max
      i = [i, image.length - 1].min
      j = [0, j].max
      j = [j, image.length - 1].min
      code << image[i][j]
    end
  end
  code.join.gsub("#", "1").gsub(".", "0").to_i(2)
end

def decode(image, algo)
  new_image = Array.new(image.length) { Array.new(image.length) }
  for i in 0..image.length-1
    for j in 0..image.length-1
      position = position(image, i-1..i+1, j-1..j+1)
      new_image[i][j] = algo[position]
    end
  end
  new_image
end

def star_one(image, algo)
  2.times do |i|
    pad_char = i == 0 ? "." : image[0][0]
    pad(image, pad_char)
    image = decode(image, algo)
  end
  image.sum { |l| l.count("#") }
end

def star_two(image, algo)
  50.times do |i|
    pad_char = i == 0 ? "." : image[0][0]
    pad(image, pad_char)
    image = decode(image, algo)
  end
  image.sum { |l| l.count("#") }
end

algo, lines = File.read("20_input.txt").split("\n\n")
image = lines.split("\n").map(&:chars)

puts star_one(image, algo)
puts star_two(image, algo)