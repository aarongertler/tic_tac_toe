# Writing out a Rosetta Code implementation of tic-tac-toe
# http://rosettacode.org/wiki/Tic-tac-toe#Ruby
# Goal: Get a sense for how others work in Ruby

require 'set'

module TicTacToe
  LINES = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]

  class Game
    def initialize(player_1_class, player_2_class)
      @board = Array.new(10) # Ignore index 0 for ease of use

      @current_player_id = 0
      @players = [player_1_class.new(self, "X"), player_2_class.new(self, "O")]
      puts "#{current_player} goes first."
    end

    attr_reader :board, :current_player_id

    def play
      loop do 
        place_player_marker(current_player)

        if player_has_won?(current_player)
          puts "#{current_player} wins!"
          print_board
          return
        elsif board_full?
          puts "It's a draw."
          print_board
          return
        end

        switch_players!
      end
    end

    def free_positions
      # Returns a list of numbers corresponding to those indices where a symbol can still be played
      # Convenient for giving players choices and checking for drawn games
      Set.new((1..9).select {|position| @board[position].nil?})
    end

    def place_player_marker(player)
      position = player.select_position!
      puts "#{player} selects position #{position}"
      @board[position] = player.marker
    end

    def player_has_won?(player)
      LINES.any? do |line|
        line.all? {|position| @board[position] == player.marker}
      end
    end

    def board_full?
      free_positions.empty?
    end

    def other_player_id
      1 - @current_player_id
    end

    def switch_players!
      @current_player_id = other_player_id
    end

    def current_player
      @players[current_player_id]
    end

    def opponent
      @players[other_player_id]
    end

    def turn_num
      10 - free_positions.size
    end

    def print_board
      col_separator, row_separator = " | ", "--+---+--"
      label_for_position = lambda{|position| @board[position] ? @board[position] : position}

      row_for_display = lambda{|row| row.map(&label_for_position).join(col_separator)}
      row_positions = [[1,2,3],[4,5,6],[7,8,9]]
      rows_for_display = row_positions.map(&row_for_display)
      puts rows_for_display.join("\n" + row_separator + "\n")
    end
  end

  class Player
    def initialize(game, marker)
      @game = game
      @marker = marker
    end

    attr_reader :marker
  end

  class HumanPlayer < Player
    def select_position!
      @game.print_board
      loop do
        print "Select your position: "
        selection = gets.to_i
        return selection if @game.free_positions.include?(selection)
        puts "Position #{selection} is not available. Try again."
      end
    end

    def to_s
      "Human"
    end
  end

  class ComputerPlayer < Player
    DEBUG = false # Set as "true", and you'll get lots of handy messages (something to try elsewhere!)

    def group_positions_by_markers(line)
      markers = line.group_by {|position| @game.board[position]}
      markers.default = []
      markers
    end

    def select_position!
      opponent_marker = @game.opponent.marker

      winning_or_blocking_position = look_for_winning_or_blocking_position(opponent_marker)
      return winning_or_blocking_position if winning_or_blocking_position

      if corner_trap_defense_needed?
        return corner_trap_defense_position(opponent_marker)
      end

      # Below returns a real position, not "true" or "false", b/c "find" is used in the method
      return random_prioritized_position
    end

    def look_for_winning_or_blocking_position(opponent_marker)
      for line in LINES # Check all the rows/columns/diagonals to see if you can win, or must block
        markers = group_positions_by_markers(line)
        next if markers[nil].length != 1 # No one is about to win on this row/column/diagonal
        if markers[self.marker].length == 2
          log_debug "winning on line #{line.join}"
          return markers[nil].first
        elsif markers[opponent_marker].length == 2
          log_debug "could block on line #{line.join}"
          blocking_position = markers[nil].first
        end
      end

      if blocking_position
        log_debug "blocking at #{blocking_position}"
        return blocking_position
      end
    end

    def corner_trap_defense_needed?
      corner_positions = [1, 3, 7, 9]
      opponent_chose_a_corner = corner_positions.any?{|pos| @game.board[pos] != nil}
      return @game.turn_num == 2 && opponent_chose_a_corner
    end

    def corner_trap_defense_position(opponent_marker)
      log_debug "defending against corner start by playing adjacent marker"
      opponent_position = @game.board.find_index {|marker| marker == opponent_marker}
      safe_responses = {1=>[2,4], 3=>[2,6], 7=>[4,8], 9=>[6,8]}
      return safe_responses[opponent_position].sample
    end

    def random_prioritized_position
      # Take center if possible, otherwise take a random open corner, otherwise take a random open side
      ([5] + [1,3,7,9].shuffle + [2,4,6,8].shuffle).find do |pos|
        @game.free_positions.include?(pos)
      end
    end

    def log_debug(message)
      puts "#{self}: #{message}" if DEBUG
    end

    def to_s
      "Computer#{@game.current_player_id}"
    end
  end
end

include TicTacToe

# Game.new(ComputerPlayer, ComputerPlayer).play
puts
players_with_human = [HumanPlayer, ComputerPlayer].shuffle
Game.new(*players_with_human).play

