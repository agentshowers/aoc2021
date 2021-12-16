#!/usr/bin/ruby

SUM = 0
PRODUCT = 1
MINIMUM = 2
MAXIMUM = 3
LITERAL = 4
GREATER_THAN = 5
LESS_THAN = 6
EQUAL_TO = 7

def aggregate_one(version, type, values)
  if type == LITERAL
    version
  else
    version + values.sum
  end
end

def aggregate_two(version, type, values)
  case type
  when SUM
    values.sum
  when PRODUCT
    values.inject(:*)
  when MINIMUM
    values.min
  when MAXIMUM
    values.max
  when LITERAL
    values.first
  when GREATER_THAN
    values[0] > values[1] ? 1 : 0
  when LESS_THAN
    values[0] < values[1] ? 1 : 0
  when EQUAL_TO
    values[0] == values[1] ? 1 : 0
  end
end

def decode(transmission, start, agg_method)
  version = transmission[start..start+2].to_i(2)
  type = transmission[start+3..start+5].to_i(2)
  if type == LITERAL
    literal_s = ""
    i = start + 6
    loop do
      prefix = transmission[i]
      literal_s += transmission[i+1..i+4]
      i += 5
      break if prefix == "0"
    end
    literal = literal_s.to_i(2)
    value = agg_method.call(version, type, [literal])
    return [i, value]
  else
    length_type = transmission[start+6].to_i
    if length_type == 0
      length = transmission[start+7..start+21].to_i(2)
      i = start + 22
      values = []
      loop do
        i, sub_value = decode(transmission, i, agg_method)
        values << sub_value
        break if i >= start+21+length
      end
      value = agg_method.call(version, type, values)
      return [i, value]
    else
      n_packets = transmission[start+7..start+17].to_i(2)
      values = []
      i = start+18
      while n_packets > 0
        i, sub_value = decode(transmission, i, agg_method)
        values << sub_value
        n_packets -= 1
      end
      value = agg_method.call(version, type, values)
      return [i, value]
    end
  end
end

def star_one(transmission)
  i, value = decode(transmission, 0, method(:aggregate_one))
  value
end

def star_two(transmission)
  i, value = decode(transmission, 0, method(:aggregate_two))
  value
end

hex = File.read("16_input.txt").chomp
transmission = hex.chars.map{ |s| s.hex.to_s(2).rjust(4, "0") }.join

puts star_one(transmission)
puts star_two(transmission)
