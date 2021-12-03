#!/usr/bin/ruby

def star_one(binaries)
  most_common = [0] * binaries[0].length

  binaries.each do |bin|
    bin.chars.each_with_index do |n, i|
      most_common[i] += n == "0" ? -1 : 1
    end
  end

  gamma = 0
  epsilon = 0

  most_common.reverse.each_with_index do |n, i|
    multiplier = n > 0 ? 1 : 0
    gamma += multiplier * (2 ** i)
    epsilon += (1 - multiplier) * (2 ** i)
  end

  gamma * epsilon
end

def calculate_gas(binaries)
  candidates = (0..binaries.length - 1).to_a

  i = 0
  while i < binaries[0].length
    ones = []
    zeroes = []

    candidates.each do |idx|
      if binaries[idx][i] == "0"
        zeroes << idx
      else
        ones << idx
      end
    end

    candidates = yield(zeroes, ones)
    break if candidates.length == 1
    i += 1
  end

  binaries[candidates[0]].to_i(2)
end

def star_two(binaries)
  oxygen = calculate_gas(binaries) do |zeroes, ones|
    ones.length >= zeroes.length ? ones : zeroes
  end
  co2 = calculate_gas(binaries) do |zeroes, ones|
    ones.length >= zeroes.length ? zeroes : ones
  end

  oxygen * co2
end

binaries = File.readlines("03_input.txt", chomp: true)

puts star_one(binaries)
puts star_two(binaries)
