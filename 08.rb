#!/Users/joao/.rbenv/shims/ruby

NUMBERS = ["abcefg", "cf", "acdeg", "acdfg", "bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"]

def star_one(notes)
  notes.sum { | _, digits | digits.count { |d| [2, 3, 4, 7].include?(d.length) } }
end

def update_mapping(code, number, mapping)
  code.chars.each do |c|
    mapping[c] = mapping[c].intersection(number.chars)
  end
  (("a".."g").to_a - code.chars).each do |c|
    mapping[c] = mapping[c] - number.chars
  end
end

def get_mapping(signal, digits)
  mapping = {}
  ("a".."g").each { |l| mapping[l] = ("a".."g").to_a }

  one = (signal + digits).select { |s| s.length == 2 }.first
  if one
    update_mapping(one, NUMBERS[1], mapping)

    six = (signal + digits).select { |s| s.length == 6 && s.chars.intersection(one.chars).length == 1 }.first
    update_mapping(six.chars.intersection(one.chars)[0], "f", mapping) if six
  end

  four = (signal + digits).select { |s| s.length == 4 }.first
  if four
    update_mapping(four, NUMBERS[4], mapping)

    zero = (signal + digits).select { |s| s.length == 6 && s.chars.intersection(four.chars).length == 1 }.first
    update_mapping(zero.chars.intersection(four.chars)[0], "b", mapping) if zero

    nine = (signal + digits).select { |s| s.length == 6 && s.chars.intersection(four.chars).length == 4 }.first
    update_mapping((("a".."g").to_a - nine.chars).join, "e", mapping) if nine
  end

  seven = (signal + digits).select { |s| s.length == 3 }.first
  if seven
    update_mapping(seven, NUMBERS[7], mapping)

    three = (signal + digits).select { |s| s.length == 5 && s.chars.intersection(seven.chars).length == 3 }.first
    if three
      d_or_g = three.chars - seven.chars
      d_mapping = d_or_g.select { |s| !mapping[s].include?("g") }.first
      update_mapping(d_mapping, "d", mapping)
    end
  end

  eight = (signal + digits).select { |s| s.length == 7 }.first
  update_mapping(eight, NUMBERS[8], mapping) if eight
  
  mapping
end

def star_two(notes)
  total = 0
  notes.each do |signal, digits|
    mapping = get_mapping(signal, digits)
    decoded = digits.map { |d| d.chars.map { |c| mapping[c] }.sort.join }
    numbers = decoded.map { |code| NUMBERS.index(code) }
    total += numbers.join.to_i
  end
  total
end

notes = File.readlines("08_input.txt", chomp: true).map do |line|
  signals, digits = line.split(" | ")
  [signals.split(" "), digits.split(" ")]
end

puts star_one(notes)
puts star_two(notes)
