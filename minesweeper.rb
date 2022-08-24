require_relative "board"

class MinesweeperGame
    LAYOUTS = { small: { grid_size: 9, num_bombs: 10 },
                medium: { grid_size: 16, num_bombs: 40 },
                large: { grid_size: 32, num_bombs: 160 } }

    def initialize(size)
        layout = LAYOUTS[size]
        @board = Board.new(layout[:grid_size], layout[:num_bombs])
    end

    def play
        until @board.won? || @board.lost?
            system("clear")
            puts @board.render

            action, pos = get_move
            perform_action(action, pos)
        end

        if @board.won?
            puts "You win!"
        elsif @board.lost?
            system("clear")
            puts "**Bomb hit!**"
            puts @board.reveal 
        end
    end

    private

    def get_move
        puts "Please enter an action and position (i.e. e,0,5):"
        print ">> "
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

if $PROGRAM_NAME == __FILE__
    MinesweeperGame.new(:small).play
end