#!/Users/joao/.rbenv/shims/ruby

PAIRS = {
  ")" => "(",
  "]" => "[",
  "}" => "{",
  ">" => "<"
}
POINTS = {
  ")" => 3,
  "]" => 57,
  "}" => 1197,
  ">" => 25137,
  "(" => 1,
  "[" => 2,
  "{" => 3,
  "<" => 4
}

def analyze(line)
  stack = []
  points = 0
  corrupted = false
  line.chars.each do |c|
    if PAIRS[c]
      if PAIRS[c] == stack.last
        stack.pop
      else
        corrupted = true
        points = POINTS[c]
        break
      end
    else
      stack << c
    end
  end
  if !corrupted
    points = stack.reverse.inject(0) do |product, c|
      product *= 5
      product + POINTS[c]
    end
  end
  [corrupted, points]
end

def star_one(lines)
  lines.sum do |line|
    corrupted, points = analyze(line)
    corrupted ? points : 0
  end
end

def star_two(lines)
  incomplete = lines.filter_map do |line| analyze(line)
    corrupted, points = analyze(line)
    points if !corrupted
  end
  incomplete.sort[incomplete.length / 2]
end

lines = File.readlines("10_input.txt", chomp: true)

puts star_one(lines)
puts star_two(lines)
