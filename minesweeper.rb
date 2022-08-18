require_relative "board"

clase MinesweeperGame
    def initialize
        @board = Board.new
    end

    def play
        until @board.won? || @board.lost?
            puts @board.render

            action, pos = get_move
            perform_action(action, pos)
        end

        if @board.won?
            puts "You win!"
        elsif @board.lost?
            puts "**Bomb hit!**"
            @board.reveal
        end
    end

    private

    def get_move
        puts "Please enter an action and position (i.e. e,0,5):"
        puts ">> "
        action, row, col = gets.chomp.split(",")

        [action, [row.to_i, col.to_i]]
    end

    def perform_action(action, pos)
        tile = @board[pos]

        case action
        when "f"
            tile.toggle_flag
        when "e"
            tile.explore
        end
    end
end