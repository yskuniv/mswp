require "md_array"

module MSwp
  class MSwp
    class IllegalParameterSpecified < ArgumentError; end

    class IllegalSizeSpecified < IllegalParameterSpecified; end

    class IllegalMinesCountSpecified < IllegalParameterSpecified; end

    class TooManyMinesCountSpecified < IllegalParameterSpecified; end

    class Error < StandardError; end

    class GameEnd < Error; end

    class GameOver < GameEnd; end

    class GameClear < GameEnd; end

    def initialize(size, mines_count)
      all_cells_count = size.reduce(&:*)

      validate_parameters(size, all_cells_count, mines_count)

      @cells = MdArray::MdArray.new(size) { Cell.new }
      @size = size
      @all_cells_count = all_cells_count
      @mines_count = mines_count
      @untouched_cells_count = all_cells_count
      @flagged_cells_count = 0
      @active = false
    end

    def touch(pos)
      initialize_cells(pos) unless @active

      begin
        @cells[pos].touch

        @untouched_cells_count -= 1

        touch_neighbors(pos) if @cells[pos].neighbor_mines_count == 0

        if @untouched_cells_count == @mines_count
          @active = false
          raise GameClear
        end
      rescue Cell::MinedCellTouched
        @active = false
        raise GameOver
      end
    end

    def flag(pos)
      @cells[pos].flag

      @flagged_cells_count += 1
    end

    def toggle_flag(pos)
      flagged = @cells[pos].toggle_flag
      if flagged
        @flagged_cells_count += 1
      else
        @flagged_cells_count -= 1
      end
    end

    def toggle_doubt(pos)
      @cells[pos].toggle_doubt
    end

    def touch_neighbors(pos)
      cell = @cells[pos]
      neighborhood = @cells.neighborhood_with_index(pos).to_a
      flagged_cells = neighborhood.select { |c, _| c.flagged }

      return unless cell.neighbor_mines_count == flagged_cells.count

      (neighborhood - flagged_cells).each do |_, p|
        begin touch(p); rescue Cell::TouchedCellTouched; end # rubocop: disable Lint/SuppressedException
      end
    end

    def flag_neighbors(pos)
      cell = @cells[pos]
      untouched_cells = @cells.neighborhood_with_index(pos).reject { |c, _| c.touched }

      return unless cell.neighbor_mines_count == untouched_cells.count

      untouched_cells.each do |_, p|
        begin flag(p); rescue Cell::FlaggedCellFlagged; end # rubocop: disable Lint/SuppressedException
      end
    end

    def each_cell_pos(&block)
      @cells.each_index(&block)
    end

    def each_cell_with_pos(&block)
      @cells.each_with_index(&block)
    end

    def mined(pos)
      @cells[pos].mined
    end

    def touched(pos)
      @cells[pos].touched
    end

    def flagged(pos)
      @cells[pos].flagged
    end

    def doubted(pos)
      @cells[pos].doubted
    end

    attr_reader :size, :mines_count, :untouched_cells_count, :flagged_cells_count, :active

    private

    def validate_parameters(size, all_cells_count, mines_count)
      raise IllegalSizeSpecified unless size.all? { |v| v >= 1 }
      raise IllegalMinesCountSpecified unless mines_count >= 0
      raise TooManyMinesCountSpecified unless mines_count < all_cells_count
    end

    def initialize_cells(reject_pos)
      @cells.each(&:reset)

      mine(@mines_count, reject_pos)

      @untouched_cells_count = @all_cells_count
      @flagged_cells_count = 0
      @active = true
    end

    def mine(count, reject_pos)
      chosen_cells = each_cell_with_pos.reject { |_, p| p == reject_pos }.to_a.sample(count)

      chosen_cells.each do |cell, pos|
        cell.mine

        @cells.neighborhood(pos).each do |c|
          c.neighbor_mines_count += 1
        end
      end
    end
  end
end
