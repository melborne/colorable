class Colorable::Colorset
  COLORNAMES = Colorable::Converter::COLORNAMES
  include Enumerable

  def initialize(colorset=nil)
    @pos = 0
    @colorset = colorset || COLORNAMES.map { |name, rgb| Colorable::Color.new(name) }
  end

  # +Colorset[:order]+ create a ordered colorset by passing a order key.
  def self.[](order, dir=:+)
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
      new.sort_by(&blk)
    when :-
      new.sort_by(&blk).reverse
    else
      raise ArgumentError, "it must ':+' or ':-'"
    end
  end

  def each(&blk)
    @colorset.each(&blk)
  end

  def at(pos=0)
    @colorset[pos]
  end

  def next(n=1)
    @pos += n
    at @pos
  end

  def prev(n=1)
    @pos -= n
    at @pos
  end

  def rewind
    @pos = 0
    at @pos
  end
  
  def last(n=1)
    @colorset.last(n)
  end

  def first(n=1)
    @colorset.first(n)
  end

  def sort_by(&blk)
    self.class.new @colorset.sort_by(&blk)
  end

  def reverse
    self.class.new @colorset.reverse
  end
end
