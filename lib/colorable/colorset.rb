require "forwardable"

module Colorable
  class Colorset
    include Enumerable
    extend Forwardable

    def initialize(colorset=nil)
      @pos = 0
      @colorset =
        colorset || COLORNAMES.map { |name, rgb| Colorable::Color.new(name) }
    end

    def_delegators :@colorset, :size, :first, :last, :to_a

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
        when :name, :rgb, :hsb, :hsv
          ->color{ color.send order }
        else
          raise ArgumentError, "First argument '#{order}' is inappropriate."
        end

      case dir
      when :+
        new(colorset).sort_by(&blk)
      when :-
        new(colorset).sort_by(&blk).reverse
      else
        raise ArgumentError, "Second argument must ':+' or ':-'."
      end
    end

    def each(&blk)
      @colorset.each(&blk)
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
  
    def find_index(color)
      idx = @colorset.find_index { |c| c == color }
      (@pos+idx)%size if idx
    end

    def sort_by(&blk)
      self.class.new @colorset.sort_by(&blk)
    end

    def reverse
      self.class.new @colorset.reverse
    end
 
    def to_s
      "#<%s %d/%d pos='%s:%s'>" % [:Colorset, @pos, size, at.name, at]
    end
    alias :inspect :to_s
  end
end