require "game"

# describe Game do
	

describe Game do

	let(:game) { Game.new("Aaron", "Tammy") }

	# describe ".initialize" do
	# 	it "creates an empty board" do
	# 		expect(game.board.state).to eq(" #{state[:a1]} #{state[:a2]} #{state[:a3]}
 #        \n #{state[:b1]} #{state[:b2]} #{state[:b3]}
 #        \n #{state[:c1]} #{state[:c2]} #{state[:c3]}")
	# 	end
	# end

	describe ".initialize" do

		it "saves the names of the players" do
			expect(game.player_1.name).to eq("Aaron")
			expect(game.player_2.name).to eq("Tammy")
		end

	end

	describe ".victory_or_tie_check" do

		before do
			game.active_player = game.player_1
			game.board.add_move("a1", "X")
			game.board.add_move("b2", "O")
			game.board.add_move("c3", "X")
		end

		it "correctly evaluates unfinished games" do
			expect(game.victory_or_tie_check).to eq(false)
		end

		it "correctly evaluates victories" do
			game.board.state[:b2] = "X"
			expect(game.victory_or_tie_check).to eq(true)
			expect(game.winner).to eq(game.player_1)
		end

		it "correctly evaluates ties" do
			game.board.state[:a1] = "O"
			game.board.state[:a2] = "O"
			game.board.state[:a3] = "X"
			game.board.state[:b1] = "X"
			game.board.state[:b2] = "X"
			game.board.state[:b3] = "O"
			game.board.state[:c1] = "O"
			game.board.state[:c2] = "X"
			game.board.state[:c3] = "X"

			expect(game.victory_or_tie_check).to eq(true)
			expect(game.winner).to eq("tie game")
		end
	end
end

	# describe ".victory_or_tie_check" do
	# 	before do
	# 		game.add_move(a1, "X")
	# 		game.add_move(b2, "X")
	# 		game.add_move(c3, "X")
	# 	end

	# 	it "correctly finds a winner" do
	# 		# expect
	# 	end

	# end