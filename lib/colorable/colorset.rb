require "forwardable"

module Colorable
  class Colorset
    include Enumerable
    extend Forwardable

    # Create a X11 colorset object.
    #
    # options::keys should be:
    #          +order+:: :NAME(default), :RGB, :HSB or :HEX can be specified.
    #          +dir+:: set :+(default) to increment order, :- to decrement order.
    #          +colorset+:: set original colorset other than X11 if any.
    def initialize(opt={})
      opt = { order: :name, dir: :+ }.merge(opt)
      @pos = 0
      @colorset = opt[:colorset] ? opt[:colorset] : build_colorset(opt)
    end

    def_delegators :@colorset, :size, :first, :last, :to_a

    def each(&blk)
      @colorset.each(&blk)
    end

    # Returns a top color object in colorset
    def at(pos=0)
      @colorset[(@pos+pos)%size]
    end

    # Returns a next color object in colorset
    def next(n=1)
      @pos = (@pos+n)%size
      at
    end

    # Returns a previous color object in colorset
    def prev(n=1)
      @pos = (@pos-n)%size
      at
    end

    # Rewind a cursor to the top
    def rewind
      @pos = 0
      at
    end
  
    def find_index(color)
      idx = @colorset.find_index { |c| c == color }
      (@pos+idx)%size if idx
    end

    # Returns a sorted colorset defined by passed block
    def sort_by(&blk)
      self.class.new colorset: @colorset.sort_by(&blk)
    end

    # Returns a reversed colorset
    def reverse
      self.class.new colorset: @colorset.reverse
    end
 
    def to_s
      "#<%s %d/%d pos='%s/%s/%s'>" % [:Colorset, @pos, size, at.name, at.rgb, at.hsb]
    end
    alias :inspect :to_s

    private
    def build_colorset(opt)
      rgb_part = [:red, :green, :blue]
      hsb_part = [:hue, :sat, :bright]

      order = opt[:order].downcase.intern

      mode =
        case order
        when :name then :NAME
        when :rgb, *rgb_part then :RGB
        when :hsb, :hsv, *hsb_part then :HSB
        when :hex then :HEX
        else
          raise ArgumentError, "Invalid order option given"
        end

      colorset = COLORNAMES.map do |name, _|
                   Colorable::Color.new(name).tap {|c| c.mode = mode }
                 end

      order_cond =
        case order
        when *rgb_part
          ->color{ color.rgb.move_to_top rgb_part.index(order) }
        when *hsb_part
          ->color{ color.hsb.move_to_top hsb_part.index(order) }
        when :name, :rgb, :hsb, :hsv, :hex
          ->color{ color.send order }
        end

      case opt[:dir].intern
      when :+
        colorset.sort_by(&order_cond)
      when :-
        colorset.sort_by(&order_cond).reverse
      else
        raise ArgumentError, "Invalid dir option given"
      end
    end
  end
end