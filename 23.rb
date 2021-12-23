#!/Users/joaoamorim/.rvm/rubies/ruby-3.0.0/bin/ruby

MAXINT = (2**(0.size * 8 -2) -1)
ROOMS = { "A" => 0, "B" => 1, "C" => 2, "D" => 3 }
ENERGY = { "A" => 1, "B" => 10, "C" => 100, "D" => 1000 }

State = Struct.new(:hallway, :rooms, :room_size) do

  def valid_moves
    in_moves + out_moves
  end

  def in_moves
    moves = []
    hallway.each_with_index do |x, i|
      next if x == "."
      room = ROOMS[x]
      position = (room+1)*2
      next if rooms[room].any? { |y| y != x }
      next if position > i && hallway[i+1..position].any? { |y| y != "." } 
      next if position < i && hallway[position..i-1].any? { |y| y != "." }
      n_moves = (position - i).abs + (room_size - rooms[room].length)
      energy = n_moves * ENERGY[x]
      moves << Move.new(room, i, true, energy)
    end
    moves.sort_by(&:energy)
  end

  def out_moves
    moves = []
    rooms.each_with_index do |room, i|
      next if room.empty?
      next if room.uniq.length == 1 && ROOMS[room.first] == i
      room_pos = (i+1)*2
      positions = []
      j = room_pos
      while j < hallway.length do
        break if hallway[j] != "."
        positions << j if j % 2 == 1 || j == 10
        j += 1
      end
      j = room_pos
      while j >= 0 do
        break if hallway[j] != "."
        positions << j if j % 2 == 1 || j == 0
        j -= 1
      end
      positions.each do |pos|
        n_moves = (pos - room_pos).abs + (room_size + 1 - room.length)
        energy = n_moves * ENERGY[room.last]
        moves << Move.new(i, pos, false, energy)
      end
    end
    moves.sort_by(&:energy)
  end

  def finished?
    rooms.each_with_index do |room, index|
      return false unless room.length == room_size && room.uniq.length == 1 && ROOMS[room.first] == index
    end
    true
  end

  def apply_move(move)
    if move.in
      amphipod = hallway[move.hall_position]
      hallway[move.hall_position] = "."
      rooms[move.room].push(amphipod)
    else
      amphipod = rooms[move.room].pop
      hallway[move.hall_position] = amphipod
    end
  end

  def key
    "#{hallway.join}-#{rooms.map { |r| r.join}.join("-")}"
  end

  def clone
    new_hallway = hallway.dup
    new_rooms = rooms.map(&:dup)
    State.new(new_hallway, new_rooms, room_size)
  end
end

Move = Struct.new(:room, :hall_position, :in, :energy)

def next_move(state, memo)
  return memo[state.key] if memo[state.key]
  return [true, 0] if state.finished?

  moves = state.valid_moves
  return [false, 0] if moves.empty?

  best = MAXINT

  moves.each do |move|
    new_state = state.clone
    new_state.apply_move(move)
    valid, energy = next_move(new_state, memo)
    best = [energy + move.energy, best].min if valid
  end

  result = [best != MAXINT, best]
  memo[state.key] = result
  result
end

def star_one(rooms)
  state = State.new("...........".chars, rooms, 2)
  _, energy = next_move(state, {})
  energy
end

def star_two(rooms)
  rooms[0].insert(1, "D").insert(1, "D")
  rooms[1].insert(1, "C").insert(1, "B")
  rooms[2].insert(1, "B").insert(1, "A")
  rooms[3].insert(1, "A").insert(1, "C")
  state = State.new("...........".chars, rooms, 4)
  _, energy, = next_move(state, {})
  energy
end

rooms = File.read("23_input.txt").scan(/\w/).each_slice(4).to_a.reverse.transpose

puts star_one(rooms)
puts star_two(rooms)
