# frozen_string_literal: true

class BOARD
  attr_accessor :board_itself

  include Enumerable

  def initialize
    self.board_itself = Array.new(4, ' ') { Array.new(4, ' ') }
  end

  def pretty_print_board
    print("\n--------------------\n")
    board_itself.each do |row|
      print('|')
      row.each do |space|
        print(" #{space} |")
      end
      print("\n--------------------\n")
    end
  end

  def mutate((index1, index2, value))
    if board_itself[index1.to_i][index2.to_i] == ' '
      board_itself[index1.to_i][index2.to_i] = value
      true
    else
      puts("That's already taken")
      false
    end
  end

  def at_indexes(index1, index2)
    return board_itself[index1][index2] if index1 < 4 && index1 >= 0 && index2 >= 0 && index2 < 4

    [':)']
  end

  def any?
    board_itself.any? { |row| row.any?(' ') }
  end

  def each_with_index(&block)
    board_itself.each_with_index(&block)
  end
end

class HUMAN_PLAYER
  attr_accessor :symbol

  def initialize
    print("What would you like? X/O\n")
    self.symbol = gets.chomp
  end

  def return_symbol
    symbol.to_s
  end

  def return_user(input_symbol)
    input_symbol == symbol
  end

  def user_choice
    print("Your turn: row, column\n")
    x, y = gets.chomp.split(',')
    [x, y, symbol]
  end
end

class GAME
  attr_accessor :my_board, :human1, :human2

  def initialize
    print("GAME STARTED\n")
    self.my_board = BOARD.new
    print("Human 1:\n")
    self.human1 = HUMAN_PLAYER.new
    print("Human 2: \n")
    self.human2 = HUMAN_PLAYER.new
  end

  def make_a_move1
    print("Human 1 choice!\n")
    my_board.mutate(human1.user_choice) unless my_board.mutate(human1.user_choice)
    my_board.pretty_print_board
  end

  def make_a_move2
    print("Human 2 choice!\n")
    my_board.mutate(human2.user_choice) unless my_board.mutate(human2.user_choice)
    my_board.pretty_print_board
  end

  def check_winning
    my_board.each_with_index do |row, row_index|
      # X X X
      counts = { 'X' => 0, 'O' => 0, ' ' => 0 }
      row.each { |row_value| counts[row_value] += 1 }
      if counts[human1.return_symbol] >= 3
        return 1
      elsif counts[human2.return_symbol] >= 3
        return 2
      else
        row.each_with_index do |values, values_index|
          # X
          #  X[row_index][values_index]
          #   X
          if values == my_board.at_indexes(row_index - 1, values_index - 1) &&
             values == my_board.at_indexes(row_index + 1, values_index + 1)
            if human1.return_symbol == values
              return 1
            elsif human2.return_symbol == values
              return 2
            end
          #    X
          #  X[row_index][values_index]
          # X
          elsif values == my_board.at_indexes(row_index - 1, values_index + 1) &&
                values == my_board.at_indexes(row_index + 1, values_index - 1)
            if human1.return_symbol == values
              return 1
            elsif human2.return_symbol == values
              return 2
            end
            # X
            # X
            # X
          elsif values == my_board.at_indexes(row_index + 1, values_index) &&
                values == my_board.at_indexes(row_index - 1, values_index)
            puts("#{row_index} and #{values_index}")
            if human1.return_symbol == values
              return 1
            elsif human2.return_symbol == values
              return 2
            end
          end
        end
      end

      return 0
    end
  end

  def check_if_board_full
    my_board.any?
  end

  def end_game(human)
    print("Human #{human} WON!\n")
    print("------GAME ENDED--------\n")
  end
end

def game_itsel(willingness_to_play)
  if willingness_to_play
    my_game = GAME.new
    while my_game.check_if_board_full && my_game.check_winning.zero?
      my_game.make_a_move1
      my_game.make_a_move2 if my_game.check_winning.zero?
    end
    my_game.end_game(my_game.check_winning)
    puts('WANT TO PLAY AGAIN? true/faslse')
    game_itsel((true if gets.chomp == 'true'))
  else
    puts('BYE!!')
  end
end

game_itsel(true)
