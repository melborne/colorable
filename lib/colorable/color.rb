module Colorable
  class Color
    class ColorNameError < StandardError; end
    include Colorable::Converter
    include Comparable
    attr_reader :name, :rgb

    def initialize(name_or_rgb)
      @name, @rgb, @hex, @hsb = nil
      case name_or_rgb
      when String, Symbol
        @name = varidate_name(name_or_rgb)
        @rgb = RGB.new *name2rgb(@name)
      when Array
        @rgb = RGB.new *validate_rgb(name_or_rgb)
        @name = rgb2name(@rgb.to_a)
      when RGB
        @rgb = name_or_rgb
        @name = rgb2name(@rgb.to_a)
      when HSB
        @hsb = name_or_rgb
        @rgb = RGB.new *hsb2rgb(@hsb.to_a)
        @name = rgb2name(@rgb.to_a)
        @mode = @hsb
      else
        raise ArgumentError, "'#{name_or_rgb}' is wrong argument. Colorname, Array of RGB values, RGB object or HSB object are acceptable"
      end
      @mode ||= @rgb
    end

    def mode
      "#{@mode.class}"[/\w+$/].intern
    end

    def mode=(mode)
      @mode =
        [rgb, hsb].detect { |c| c.class.to_s.match /#{mode}/i }
                  .tap { |cs| raise ArgumentError, "Only accept :RGB or :HSB" unless cs }
      mode
    end

    def to_s
      @mode.to_s
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
      self.name <=> other.name
    end

    @@colorset = {}
    def next(set=:name, n=1)
      @@colorset[set] ||= Colorable::Colorset[set]
      idx = @@colorset[set].find_index(self)
      @@colorset[set].at(idx+n) if idx
    end

    def prev(set=:name, n=1)
      self.next(set, -n)
    end

    def dark?
      DARK_COLORS.detect { |d| d == self.name }
    end

    def +(arg)
      self.class.new @mode + arg
    end

    def -(arg)
      self.class.new @mode - arg
    end

    private
    def varidate_name(name)
      COLORNAMES.detect do |label, _|
        [label, name].same? { |str| "#{str}".gsub(/[_\s]/,'').downcase }
      end.tap do |res, _|
        raise ColorNameError, "'#{name}' is not a valid colorname" unless res
        break res
      end
    end
  end
end