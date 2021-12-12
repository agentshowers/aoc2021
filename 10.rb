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
  line.chars.each do |c|
    if !PAIRS[c]
      stack << c
    elsif PAIRS[c] == stack.last
      stack.pop
    else
      return -POINTS[c]
    end
  end
  stack.reverse.inject(0) { |p, c| p * 5 + POINTS[c] }
end

def star_one(lines)
  lines.sum do |line|
    points = analyze(line)
    points < 0 ? -points : 0
  end
end

def star_two(lines)
  incomplete = lines.filter_map do |line| analyze(line)
    points = analyze(line)
    points if points > 0
  end
  incomplete.sort[incomplete.length / 2]
end

lines = File.readlines("10_input.txt", chomp: true)

puts star_one(lines)
puts star_two(lines)
