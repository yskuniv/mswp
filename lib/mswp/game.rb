module MSwp
  class Game
    class QuitKeyPressed < StandardError; end

    class << self
      def start(size, mines_count, auto = false)
        self.new.start(size, mines_count, auto)
      end
    end

    def start(size, mines_count, auto)
      mswp = MSwp.new(size, mines_count)

      init_game(size)

      th = start_timer_thread

      begin
        loop do
          print_field(mswp)

          input = get_input

          begin
            handle_input(mswp, input)

            if auto
              handle_auto(mswp)
            end
          rescue Cell::TouchedCellTouched
            handle_touched_cell_touched(mswp)
          rescue Cell::TouchedCellFlagged
            handle_touched_cell_flagged(mswp)
          rescue Cell::TouchedCellDoubted
            handle_touched_cell_doubted(mswp)
          rescue Cell::FlaggedCellTouched
            handle_flagged_cell_touched(mswp)
          rescue Cell::FlaggedCellFlagged
            handle_flagged_cell_flagged(mswp)
          end
        end
      rescue MSwp::GameEnd => e
        th.kill

        if e.is_a? MSwp::GameOver
          print_field(mswp, game_over: true)
          handle_game_over(mswp)
        else
          print_field(mswp, game_clear: true)
          handle_game_clear(mswp)
        end
      rescue QuitKeyPressed
        # do nothing
      end

      cleanup_game
    end

    def init_game(size)
    end

    def print_field(mswp, game_over: false, game_clear: false)
    end

    def print_time(count)
    end

    def get_input # rubocop: disable Naming/AccessorMethodName
    end

    def handle_input(mswp, input)
    end

    def handle_auto(mswp)
    end

    def handle_touched_cell_touched(mswp)
    end

    def handle_touched_cell_flagged(mswp)
    end

    def handle_touched_cell_doubted(mswp)
    end

    def handle_flagged_cell_touched(mswp)
    end

    def handle_flagged_cell_flagged(mswp)
    end

    def handle_game_over(mswp)
    end

    def handle_game_clear(mswp)
    end

    def cleanup_game
    end

    private

    def start_timer_thread
      Thread.new do
        count = 0

        loop do
          print_time(count)
          sleep 1
          count += 1
        end
      end
    end
  end
end
