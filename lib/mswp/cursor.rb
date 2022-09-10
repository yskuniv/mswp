module MSwp
  class Cursor
    def initialize(size)
      @size = size
      @pos = Array.new(size.length, 0)
    end

    def move(dim, delta)
      return unless (0...@size[dim]) === @pos[dim] + delta

      @pos[dim] += delta
    end

    attr_reader :pos
  end
end
