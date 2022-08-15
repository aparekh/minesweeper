require_relative "tile"

class Board
    attr_reader :grid_size, :num_bombs

    def initialize
        @grid_size = 9
        @num_bombs = 10

        generate_board
    end

    def [](pos)
        row, col = pos
        @grid[row][col]
    end

    def render(reveal = false)
        @grid.map do |row|
            row.map do |tile|
                reveal ? tile.reveal : tile.render
            end.join("")
        end.join("/n")
    end

    def reveal
        render(true)
    end

    def won?
        @grid.flatten.all? { |tile| tile.bombed? != tile.explored? }
    end

    def lost?
        @grid.flatten.any? { |tile| tile.bombed? && tile.explored? }
    end

    private

    def generate_board
        @grid = Array.new(@grid_size) do |row|
            Array.new(@grid_size) { |col| Tile.new(self, [row, col] )}
        end

        plant_bombs
    end

    def plant_bombs
        total_bombs = 0
        
        while total_bombs < @num_bombs
            rand_pos = Array.new(2) { rand(@grid_size) }
            tile = self[rand_pos]
            next if tile.bombed?
            tile.plant_bomb
            total_bombs += 1
        end

        nil
    end
end