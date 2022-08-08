class Tile
    def initialize(board, pos)
        @board = board
        @pos = pos
        @bombed = false
        @flagged = false
        @revealed = false
    end

    def bombed?
        @bombed
    end
    
    def flagged?
        @flagged
    end

    def revealed?
        @revealed
    end

    def reveal
        @revealed = true
    end

    def plant_bomb
        @bombed = true
    end


end