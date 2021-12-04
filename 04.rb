#!/usr/bin/ruby

MARKED = -1
NO_WIN = 0

def mark_board(board, number)
  i = 0
  while i < 5
    j = 0
    while j < 5
      if board[i][j] == number
        board[i][j] = MARKED
        return board_total(board) * number if board_won?(board, i, j)
      end
      j += 1
    end
    i += 1
  end
  NO_WIN
end

def board_won?(board, i, j)
  board[i] == [MARKED] * 5 || board.map { |b| b[j] } == [MARKED] * 5
end

def board_total(board)
  board.map { |row| row.select { |v| v !=-1 }.sum }.sum
end

def star_one(numbers, boards)
  numbers.each do |n|
    boards.each do |board|
      result = mark_board(board, n)
      return result if result != NO_WIN
    end
  end
end

def star_two(numbers, boards)
  numbers.each do |n|
    i = 0
    while i < boards.length
      result = mark_board(boards[i], n)
      if result != NO_WIN
        return result if boards.length == 1
        boards.delete_at(i)
      else
        i += 1
      end
    end
  end
end

lines = File.readlines("04_input.txt", chomp: true)
numbers = lines[0].split(",").map(&:to_i)
boards = []
i = 2
while i < lines.length
  new_board = []
  j = 0
  while j < 5
    new_board << lines[i+j].split(" ").map(&:to_i)
    j += 1
  end
  boards << new_board
  i += 6
end

puts star_one(numbers, boards)
puts star_two(numbers, boards)
