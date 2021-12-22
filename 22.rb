#!/Users/joaoamorim/.rvm/rubies/ruby-3.0.0/bin/ruby

class Cuboid

  attr_accessor :x1, :x2, :y1, :y2, :z1, :z2

  def initialize(x1, x2, y1, y2, z1, z2)
    @x1 = x1
    @x2 = x2
    @y1 = y1
    @y2 = y2
    @z1 = z1
    @z2 = z2
  end

  def split_remaining(cuboid)
    rems_x, int_x = intersect_ranges(x1, x2, cuboid.x1, cuboid.x2)
    rems_y, int_y = intersect_ranges(y1, y2, cuboid.y1, cuboid.y2)
    rems_z, int_z = intersect_ranges(z1, z2, cuboid.z1, cuboid.z2)

    return [self] if int_x.empty? || int_y.empty? || int_z.empty?

    cuboids = []
    rems_x.each { |min, max| cuboids << Cuboid.new(min, max, y1, y2, z1, z2) }
    rems_y.each { |min, max| cuboids << Cuboid.new(int_x[0], int_x[1], min, max, z1, z2) }
    rems_z.each { |min, max| cuboids << Cuboid.new(int_x[0], int_x[1], int_y[0], int_y[1], min, max) }
    cuboids
  end

  def intersect_ranges(a1, a2, b1, b2)
    return [[[a1, a2]], []] if a1 > b2 || a2 < b1
    
    int = [[a1, b1].max, [a2, b2].min]
    rems = []
    rems << [int[1]+1, a2] if a2 > int[1]
    rems << [a1, int[0]-1] if a1 < int[0]
    [rems, int]
  end

  def cube_count(limit)
    x = (x1 > limit || x2 < -limit) ? 0 : [x2, limit].min - [x1, -limit].max + 1
    y = (y1 > limit || y2 < -limit) ? 0 : [y2, limit].min - [y1, -limit].max + 1
    z = (z1 > limit || z2 < -limit) ? 0 : [z2, limit].min - [z1, -limit].max + 1
    x * y * z
  end
end

def calculate(instructions, limit)
  cuboids = []
  instructions.each do |i, x1, x2, y1, y2, z1, z2|
    cuboid = Cuboid.new(x1, x2, y1, y2, z1, z2)
    new_cuboids = []
    cuboids.each { |c| new_cuboids += c.split_remaining(cuboid) }
    new_cuboids << cuboid if i == "on"
    cuboids = new_cuboids
  end
  cuboids.sum { |c| c.cube_count(limit) }
end

def star_one(instructions)
  calculate(instructions, 50)
end

def star_two(instructions)
  calculate(instructions, 100000)
end

instructions = File.readlines("22_input.txt", chomp: true).map do |line|
  /(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)/ =~ line
  [$1, $2.to_i, $3.to_i, $4.to_i, $5.to_i, $6.to_i, $7.to_i]
end

puts star_one(instructions)
puts star_two(instructions)