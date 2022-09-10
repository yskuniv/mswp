require "curses"

module MSwp
  class CursesGame < Game
    class IllegalSizeSpecified < ArgumentError; end

    class << self
      def start(size, mines_count, auto = false)
        case size.length
        when 0
          size = [1, 1, 1, 1]
        when 1
          size = [1, 1, 1, *size]
        when 2
          size = [1, 1, *size]
        when 3
          size = [1, *size]
        when 4
          size = [*size]
        else
          raise IllegalSizeSpecified
        end

        super(size, mines_count, auto)
      end
    end

    def init_game(size)
      @cursor = Cursor.new(size)

      Curses.init_screen
      Curses.start_color
      Curses.init_pair(1, Curses::COLOR_WHITE, Curses::COLOR_BLACK)
      Curses.init_pair(2, Curses::COLOR_BLACK, Curses::COLOR_WHITE)
      Curses.init_pair(3, Curses::COLOR_RED, Curses::COLOR_WHITE)
      Curses.init_pair(4, Curses::COLOR_BLUE, Curses::COLOR_WHITE)
      Curses.init_pair(5, Curses::COLOR_BLACK, Curses::COLOR_RED)
      Curses.init_pair(6, Curses::COLOR_WHITE, Curses::COLOR_BLUE)
      Curses.init_pair(7, Curses::COLOR_BLACK, Curses::COLOR_CYAN)
      Curses.init_pair(8, Curses::COLOR_RED, Curses::COLOR_CYAN)
      Curses.init_pair(9, Curses::COLOR_BLUE, Curses::COLOR_CYAN)
      Curses.init_pair(10, Curses::COLOR_BLACK, Curses::COLOR_RED)
      Curses.init_pair(11, Curses::COLOR_WHITE, Curses::COLOR_GREEN)
      Curses.init_pair(12, Curses::COLOR_BLACK, Curses::COLOR_YELLOW)
      Curses.init_pair(13, Curses::COLOR_RED, Curses::COLOR_YELLOW)
      Curses.init_pair(14, Curses::COLOR_BLUE, Curses::COLOR_YELLOW)
      Curses.init_pair(15, Curses::COLOR_RED, Curses::COLOR_BLACK)
      Curses.noecho
      Curses.curs_set(0)
    end

    def print_field(mswp, game_over: false, game_clear: false) # rubocop: disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      size = mswp.size

      Curses.setpos(0, 0)
      header = "Mines: #{mswp.mines_count}, Flagged: #{mswp.flagged_cells_count}, Untouched: #{mswp.untouched_cells_count}, Position: (#{@cursor.pos.reverse.join(', ')})"
      Curses.attron(Curses.color_pair(2))
      Curses.addstr(header << (" " * (Curses.cols - header.length)))
      Curses.attroff(Curses::A_COLOR)

      mswp.each_cell_with_pos do |cell, pos|
        color_offset = case
                       when pos == @cursor.pos
                         10
                       when pos.each_index.all? { |i| (pos[i] - @cursor.pos[i]).abs <= 1 }
                         5
                       else
                         0
                       end

        Curses.setpos(2 + ((size[2] + 1) * pos[0]) + pos[2], (2 * (size[3] + 1) * pos[1]) + (2 * pos[3]))
        if (!game_over || mswp.active) && !cell.touched
          if cell.flagged
            Curses.attron(Curses.color_pair(3 + color_offset))
            Curses.addstr(" !")
            Curses.attroff(Curses::A_COLOR)
          elsif cell.doubted
            Curses.attron(Curses.color_pair(4 + color_offset))
            Curses.addstr(" ?")
            Curses.attroff(Curses::A_COLOR)
          else
            Curses.attron(Curses.color_pair(2 + color_offset))
            Curses.addstr("  ")
            Curses.attroff(Curses::A_COLOR)
          end
        else
          if cell.mined
            Curses.attron(Curses.color_pair(5 + color_offset))
            Curses.addstr(" *")
            Curses.attroff(Curses::A_COLOR)
          else
            Curses.attron(Curses.color_pair(1 + color_offset))
            Curses.addstr(cell.neighbor_mines_count == 0 ?
                          " ." :
                          '%2d' % cell.neighbor_mines_count)
            Curses.attroff(Curses::A_COLOR)
          end
        end
      end

      if game_over || game_clear
        Curses.setpos(2 + ((size[2] + 1) * size[0]), 0)
        case
        when game_over
          Curses.addstr('Game Over...')
        when game_clear
          Curses.addstr('Game Clear!!')
        end
      end

      Curses.refresh
    end

    def print_time(count)
      Curses.setpos(1, 0)
      Curses.addstr('TIME: %02d:%02d' % [count / 60, count % 60])
      Curses.refresh
    end

    def get_input # rubocop: disable Naming/AccessorMethodName
      Curses.getch
    end

    def handle_input(mswp, input) # rubocop: disable Metrics/CyclomaticComplexity
      case input
      when ?q
        raise Game::QuitKeyPressed
      when ?h
        @cursor.move(3, -1)
      when ?l
        @cursor.move(3, 1)
      when ?k
        @cursor.move(2, -1)
      when ?j
        @cursor.move(2, 1)
      when ?H
        @cursor.move(1, -1)
      when ?L
        @cursor.move(1, 1)
      when ?K
        @cursor.move(0, -1)
      when ?J
        @cursor.move(0, 1)
      when ?\s
        mswp.touch(@cursor.pos)
      when ?f, ?!
        mswp.toggle_flag(@cursor.pos)
      when ?d, ??
        mswp.toggle_doubt(@cursor.pos)
      end
    end

    def handle_auto(mswp)
      if mswp.touched(@cursor.pos)
        mswp.flag_neighbors(@cursor.pos)
        mswp.touch_neighbors(@cursor.pos)
      end
    end

    def handle_touched_cell_touched(mswp)
      mswp.touch_neighbors(@cursor.pos)
    end

    def handle_touched_cell_flagged(mswp)
      mswp.flag_neighbors(@cursor.pos)
    end

    def handle_game_over(_mswp)
      wait_quit_key_pressed
    end

    def handle_game_clear(_mswp)
      wait_quit_key_pressed
    end

    def cleanup_game
      Curses.close_screen
    end

    private

    def wait_quit_key_pressed
      while get_input != ?q; end
    end
  end
end
