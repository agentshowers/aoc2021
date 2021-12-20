#!/usr/bin/ruby

require 'json'

class Tree
  attr_accessor :left, :right, :value

  def initialize(left: nil, right: nil, value: nil)
    @left = left
    @right = right
    @value = value
  end

  def leaf?
    !@value.nil?
  end

  def height
    return 0 if leaf?

    1 + [@left.height, @right.height].max
  end

  def max_value
    return @value if leaf?

    [@left.max_value, @right.max_value].max
  end

  def magnitude
    return @value if leaf?

    3 * @left.magnitude + 2 * @right.magnitude
  end

  def self.from_value(value)
    if value.is_a?(Integer)
      Tree.new(value: value)
    else
      left = Tree.from_value(value[0])
      right = Tree.from_value(value[1])
      Tree.new(left: left, right: right)
    end
  end
end

def explode(tree)
  if tree.height == 1
    left_v = tree.left.value
    right_v = tree.right.value
    tree.left = nil
    tree.right = nil
    tree.value = 0
    return [left_v, right_v]
  elsif tree.right.height > tree.left.height
    left_v, right_v = explode(tree.right)
    add_value(tree.left, left_v, true) if left_v
    return [nil, right_v]
  else
    left_v, right_v = explode(tree.left)
    add_value(tree.right, right_v, false) if right_v
    return [left_v, nil]
  end
end

def add_value(tree, value, right)
  if tree.leaf?
    tree.value += value
  elsif right
    add_value(tree.right, value, right)
  else
    add_value(tree.left, value, right)
  end
end

def split(tree)
  if tree.leaf?
    half = tree.value / 2
    rem = tree.value % 2
    tree.left = Tree.new(value: half)
    tree.right = Tree.new(value: half + rem)
    tree.value = nil
  else
    tree.left.max_value >= 10 ? split(tree.left) : split(tree.right)
  end
end

def reduce(tree)
  loop do
    if tree.height > 4
      explode(tree)
    elsif tree.max_value >= 10
      split(tree)
    else
      break
    end
  end
end

def star_one(snailfish)
  tree = Tree.from_value(snailfish[0])
  for i in 1..snailfish.length-1
    tree = Tree.new(left: tree, right: Tree.from_value(snailfish[i]))
    reduce(tree)
  end
  tree.magnitude
end

def star_two(snailfish)
  max_magnitude = 0
  for i in 0..snailfish.length-1
    for j in 0..snailfish.length-1
      next if i == j
      left = Tree.from_value(snailfish[i])
      right = Tree.from_value(snailfish[j])
      tree = Tree.new(left: left, right: right)
      reduce(tree)
      max_magnitude = [tree.magnitude, max_magnitude].max
    end
  end
  max_magnitude
end

snailfish = File.readlines("18_input.txt", chomp: true).map do |line|
  JSON.parse(line)
end

puts star_one(snailfish)
puts star_two(snailfish)