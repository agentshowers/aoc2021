#!/Users/joao/.rbenv/shims/ruby

def build_pair(a, b, rules, steps, memo)
  key = "#{a}#{b}#{steps}"
  return memo[key] if memo[key]
  middle_char = rules["#{a}#{b}"]
  sum = { middle_char => 1}
  if steps > 1
    sum_left = build_pair(a, middle_char, rules, steps-1, memo)
    sum.merge!(sum_left) { |_, a, b| a + b }
    sum_right = build_pair(middle_char, b, rules, steps-1, memo)
    sum.merge!(sum_right) { |_, a, b| a + b }
  end
  memo[key] = sum
  sum
end

def calculate(template, rules, steps)
  memo = {}
  sum = { template[0] => 1}
  (1..template.length - 1).each do |i|
    int_sum = build_pair(template[i-1], template[i], rules, steps, memo)
    sum.merge!(int_sum) { |_, a, b| a + b }
    sum[template[i]] = (sum[template[i]] || 0) + 1
  end
  sorted_tally = sum.sort_by { |_, v| v }
  sorted_tally.last[1] - sorted_tally.first[1]
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
