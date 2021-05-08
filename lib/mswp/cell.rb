module MSwp
  class Cell
    class Error < StandardError; end

    class IllegalOperation < Error; end

    class TouchedCellTouched < IllegalOperation; end

    class TouchedCellFlagged < IllegalOperation; end

    class TouchedCellDoubted < IllegalOperation; end

    class FlaggedCellTouched < IllegalOperation; end

    class FlaggedCellFlagged < IllegalOperation; end

    class MinedCellTouched < Error; end

    def initialize
      reset
    end

    def mine
      @mined = true
    end

    def touch
      raise TouchedCellTouched if @touched
      raise FlaggedCellTouched if @flagged

      @touched = true

      raise MinedCellTouched if @mined
    end

    def flag
      raise TouchedCellFlagged if @touched
      raise FlaggedCellFlagged if @flagged

      @flagged = true
      @doubted = false

      @flagged
    end

    def toggle_flag
      raise TouchedCellFlagged if @touched

      if @doubted
        @flagged = true
        @doubted = false
      else
        @flagged = !@flagged
      end

      @flagged
    end

    def toggle_doubt
      raise TouchedCellDoubted if @touched

      if @flagged
        @flagged = false
        @doubted = true
      else
        @doubted = !@doubted
      end

      @doubted
    end

    def reset
      @neighbor_mines_count = 0
      @mined = false
      @touched = false
      @flagged = false
      @doubted = false
    end

    attr_accessor :neighbor_mines_count
    attr_reader :mined, :touched, :flagged, :doubted
  end
end
