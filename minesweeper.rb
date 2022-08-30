require "yaml"
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
        start_time = Time.now
        until @board.won? || @board.lost?
            system("clear")
            puts @board.render
            t2 = Time.now
            elapsed_time = t2 - start_time
            puts "Time elapsed: #{elapsed_time}"

            action, pos = get_move
            perform_action(action, pos)
        end

        if @board.won?
            finish_time = Time.now
            elapsed_time = finish_time - start_time
            puts "You win!"
            puts "You finished in #{elapsed_time} seconds."
            
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
        when "s"
            save
        end
    end

    def save
        puts "Enter filename to save at:"
        filename = gets.chomp

        File.write(filename, YAML.dump(self))
    end
end

if $PROGRAM_NAME == __FILE__
    case ARGV.count
    when 0
        MinesweeperGame.new(:small).play
    when 1
        YAML.load_file(ARGV.shift).play
    end
end