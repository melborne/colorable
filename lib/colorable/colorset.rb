module Colorable
  class Colorset
    include Enumerable

    def initialize(colorset=nil)
      @pos = 0
      @colorset =
        colorset || COLORNAMES.map { |name, rgb| Colorable::Color.new(name) }
    end

    # +Colorset[:order]+ create a ordered colorset by passing a order key.
    def self.[](order, dir=:+, colorset=nil)
      rgb = [:red, :green, :blue]
      hsb = [:hue, :sat, :bright]
      blk =
        case order
        when :red, :blue, :green
          ->color{ color.rgb.move_to_top rgb.index(order) }
        when :hue, :sat, :bright
          ->color{ color.hsb.move_to_top hsb.index(order) }
        else
          ->color{ color.send order }
        end

      case dir
      when :+
        new(colorset).sort_by(&blk)
      when :-
        new(colorset).sort_by(&blk).reverse
      else
        raise ArgumentError, "it must ':+' or ':-'"
      end
    end

    def each(&blk)
      @colorset.each(&blk)
    end

    def size
      @colorset.size
    end

    def at(pos=0)
      @colorset[(@pos+pos)%size]
    end

    def next(n=1)
      @pos = (@pos+n)%size
      at
    end

    def prev(n=1)
      @pos = (@pos-n)%size
      at
    end

    def rewind
      @pos = 0
      at
    end
  
    def last(n=1)
      @colorset.last(n)
    end

    def first(n=1)
      @colorset.first(n)
    end

    def find_index(color)
      @colorset.find_index { |c| c == color }
    end

    def sort_by(&blk)
      self.class.new @colorset.sort_by(&blk)
    end

    def reverse
      self.class.new @colorset.reverse
    end
 
    def to_a
      @colorset
    end

    def to_s
      "#<%s %d/%d pos='%s:%s'>" % [:Colorset, @pos, size, at.name, at]
    end
    alias :inspect :to_s
  end
end