# Could be sped up, but pretty happy with the cleanliness of the code

class Game 
  Player = Struct.new(:name,:symbol)
  Board = Struct.new(:state,:moved) do
    def to_s
      "#{state}"
    end

    def show
      puts " #{state[:a1]} #{state[:a2]} #{state[:a3]}
          \n #{state[:b1]} #{state[:b2]} #{state[:b3]}
          \n #{state[:c1]} #{state[:c2]} #{state[:c3]}"
    end

    def add_move(position, symbol)
      position.downcase!
      square = state[position.to_sym]
      if square == " X" || square == " O"
        puts "Error! Please choose an available square."
      elsif square != nil
        state[position.downcase.to_sym] = symbol
        moved = true
      else
        puts "Error! Please choose a real square."
      end

      return state, moved
    end

  end

  attr_accessor :player_1, :player_2
  attr_reader :board

  def initialize(player_1_name, player_2_name)
    @player_1 = Player.new(player_1_name,"X")
    @player_2 = Player.new(player_2_name,"O")
    @board = Board.new({a1: "a1", 
                        a2: "a2",
                        a3: "a3",
                        b1: "b1", 
                        b2: "b2",
                        b3: "b3",
                        c1: "c1", 
                        c2: "c2",
                        c3: "c3"}, false)
    @active_player = nil
    @winner = nil
    play_game
  end

  def victory_or_tie_check
    state = @board.state

    if state[:a1] == state[:a2] && state[:a2] == state[:a3]||
          state[:b1] == state[:b2] && state[:b2] == state[:b3]||
          state[:c1] == state[:c2] && state[:c2] == state[:c3]||
          state[:a1] == state[:b1] && state[:b1] == state[:c1]||
          state[:a2] == state[:b2] && state[:b2] == state[:c2]||
          state[:a3] == state[:b3] && state[:b3] == state[:c3]||
          state[:a1] == state[:b2] && state[:b2] == state[:c3]||
          state[:c1] == state[:b2] && state[:b2] == state[:a3]

      @winner = @active_player
      return true
    elsif state.values.uniq == ["X", "O"] # Board is completely full, but no three-in-a-rows
      @winner = "tie game"
      return true
    else
      return false
    end
  end

  def switch_active_player(player)
    @active_player = @active_player == @player_1 ? @player_2 : @player_1
  end

  def ask_for_move
    @board.show
    puts "\n #{@active_player.name}, please select your square, or enter \"exit\" to exit:"
    position = gets.chomp
    if position == "exit"
      puts "Exiting!"
      Kernel.exit
    end
    # It feels like there must be a better way to accomplish the below -> hard to make these variables move
    @board.state, @board.moved = @board.add_move(position,@active_player.symbol)
  end

  def make_move
    @board.moved = false
    switch_active_player(@active_player)
    while @board.moved == false
      ask_for_move
    end
  end

  def play_game
    until victory_or_tie_check == true do
      make_move
    end

    @board.show

    if @winner == "tie game"
      puts "It's a tie!"
    else
      puts "#{@winner.name} is the winner!"
    end
  end

end


puts "Player 1, please state your name:"
player_1_name = gets.chomp
puts "Player 2, please state your name:"
player_2_name = gets.chomp

game = Game.new(player_1_name,player_2_name)