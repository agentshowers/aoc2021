#!/Users/joaoamorim/.rvm/rubies/ruby-3.0.0/bin/ruby

def calculate(template, rules, n)
  counts = template.tally
  pairs = template.each_cons(2).tally

  n.times do
    new_pairs = {}
    pairs.each do |pair, count|
      polymer = rules[pair.join]
      counts[polymer] = (counts[polymer] || 0) + count
      new_pairs[[pair[0], polymer]] = (new_pairs[[pair[0], polymer]] || 0) + count
      new_pairs[[polymer, pair[1]]] = (new_pairs[[polymer, pair[1]]] || 0) + count
    end
    pairs = new_pairs
  end

  sorted_count = counts.sort_by { |_, v| v }
  sorted_count.last[1] - sorted_count.first[1]
end

def star_one(template, rules)
  calculate(template, rules, 10)
end

def star_two(template, rules)
  calculate(template, rules, 40)
end

lines = File.readlines("14_input.txt", chomp: true)
template = lines[0].chars
rules = {}
lines.drop(2).each do |line|
  pair, element = line.split(" -> ")
  rules[pair] = element 
end

puts star_one(template, rules)
puts star_two(template, rules)
