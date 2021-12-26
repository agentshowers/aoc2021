#!/usr/bin/ruby

cucumbers = File.readlines("25_input.txt", chomp: true).map(&:chars)

step = 0
loop do
  r_swaps = []
  d_swaps = []
  cucumbers.each_with_index do |line, i|
    next_i = (i+1) % cucumbers.length
    for j in 0..line.length-1
      next_j = (j+1) % line.length
      prev_j = j > 0 ? j - 1 : line.length - 1
      r_swaps << [[i,j],[i,next_j]] if line[j] == ">" && line[next_j] == "."
      d_swaps << [[i,j],[next_i,j]] if cucumbers[i][j] == "v" && ((cucumbers[next_i][j] == "." && cucumbers[next_i][prev_j] != ">") || (cucumbers[next_i][j] == ">" && cucumbers[next_i][next_j] == "."))
    end
  end

  r_swaps.each do |a, b|
    cucumbers[a[0]][a[1]] = "."
    cucumbers[b[0]][b[1]] = ">"
  end
  d_swaps.each do |a, b|
    cucumbers[a[0]][a[1]] = "."
    cucumbers[b[0]][b[1]] = "v"
  end

  changes = r_swaps.length + d_swaps.length

  step +=1
  break if changes == 0
end

puts step