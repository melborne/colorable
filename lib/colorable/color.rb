module Colorable
  class Color
    class NameError < StandardError; end
    include Colorable::Converter
    include Comparable
    attr_reader :name, :rgb

    def initialize(name_or_rgb)
      @name, @rgb, @hex, @hsb = nil
      case name_or_rgb
      when String, Symbol
        @name = varidate_name(name_or_rgb)
        @rgb = RGB.new *name2rgb(@name.to_s)
        @mode = @name
      when Array
        @rgb = RGB.new *validate_rgb(name_or_rgb)
        @name = NAME.new rgb2name(@rgb.to_a)
        @mode = @rgb
      when RGB
        @rgb = name_or_rgb
        @name = NAME.new rgb2name(@rgb.to_a)
        @mode = @rgb
      when HSB
        @hsb = name_or_rgb
        @rgb = RGB.new *hsb2rgb(@hsb.to_a)
        @name = NAME.new rgb2name(@rgb.to_a)
        @mode = @hsb
      else
        raise ArgumentError, "'#{name_or_rgb}' is wrong argument. Colorname, Array of RGB values, RGB object or HSB object are acceptable"
      end
    end

    def mode
      "#{@mode.class}"[/\w+$/].intern
    end

    def mode=(mode)
      @mode =
        [rgb, hsb, name].detect { |c| c.class.to_s.match /#{mode}/i }
                  .tap { |cs| raise ArgumentError, "Only accept :RGB or :HSB" unless cs }
      mode
    end

    def to_s
      @mode.to_s
    end

    def info
      {
        NAME: name.to_s,
        RGB: rgb.to_a,
        HSB: hsb.to_a,
        HEX: hex.to_s,
        MODE: mode,
        DARK: dark?
      }
    end

    def hex
      @hex ||= rgb2hex(rgb.to_a)
    end

    def hsb
      @hsb ||= HSB.new *rgb2hsb(rgb.to_a)
    end
    alias :hsv :hsb

    %w(red green blue).each do |c|
      define_method(c) { rgb.send c }
    end

    %w(hue sat bright).each do |c|
      define_method(c) { hsb.send c }
    end

    def <=>(other)
      self.rgb <=> other.rgb
    end

    @@colorset = {}
    # Returns a next color object in X11 colors.
    # The color sequence is determined by its color mode.
    def next(n=1)
      @@colorset[mode] ||= Colorable::Colorset.new(order: mode)
      idx = @@colorset[mode].find_index(self)
      @@colorset[mode].at(idx+n).tap{|c| c.mode = mode } if idx
    end

    # Returns a previous color object in X11 colors.
    # The color sequence is determined by its color mode.
    def prev(n=1)
      self.next(-n)
    end

    def dark?
      !!DARK_COLORS.detect { |d| d == name.to_s }
    end

    # Returns a color object which has incremented color values.
    # Array of values or a Fixnum is acceptable as an argument.
    # Which values are affected is determined by its color mode.
    def +(arg)
      self.class.new @mode + arg
    end

    # Returns a color object which has decremented color values.
    # Array of values or a Fixnum is acceptable as an argument.
    # Which values are affected is determined by its color mode.
    def -(arg)
      self.class.new @mode - arg
    end

    private
    def varidate_name(name)
      NAME.new(name).tap do |res|
        raise NameError, "'#{name}' is not a valid colorname" unless res.name
      end
    end
  end
end