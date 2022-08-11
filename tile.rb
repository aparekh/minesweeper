class Tile
    DELTAS = [[0, 1], [0, -1], [1, 0], [1, -1], [1, 1], [-1, 0], [-1, 1], [-1, -1]].freeze

    attr_reader :pos

    def initialize(board, pos)
        @board = board
        @pos = pos
        @bombed = false
        @flagged = false
        @explored = false
    end

    def bombed?
        @bombed
    end
    
    def flagged?
        @flagged
    end

    def explored?
        @explored
    end

    def explore
        return self if flagged?

        return self if explored?

        @explored = true
        
        if !bombed? && neighbor_bomb_count == 0
            neighbors.each(&:explore)
        end

        self
    end

    def neighbors
        adj_coords = DELTAS.map do |dx, dy|
            [pos[0] + dx, pos[1] + dy]
        end

        adj_coords.select do |row, col|
            [row, col].all? { |coord| coord.between?(0, @board.grid_size - 1) }
        end

        adj_coords.map { |pos| @board[pos] }
    end

    def neighbor_bomb_count
        neighbors.select(&:bombed?).count
    end

    def inspect
        { pos: pos, bombed: bombed?, flagged: flagged?, explored: explored? }.inspect
    end

    def render
        if flagged?
            "F"
        elsif explored?
            neighbor_bomb_count == 0 ? "_" : neighbor_bomb_count.to_s
        else
            "*"
        end
    end

    def reveal
        if flagged?
            bombed? ? "F" : "f"
        elsif bombed?
            explored? ? "X" : "B"
        else
            neighbor_bomb_count == 0 ? "_" : neighbor_bomb_count.to_s
        end
    end

    def plant_bomb
        @bombed = true
    end

    def toggle_flag
        @flagged = !@flagged unless explored?
    end
end