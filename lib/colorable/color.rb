module Colorable
  class Color
    class ColorNameError < StandardError; end
    include Colorable::Converter
    include Comparable
    attr_reader :name, :rgb

    def initialize(name_or_rgb)
      @name, @rgb, @hex, @hsb, @esc = nil
      case name_or_rgb
      when String, Symbol
        @name = varidate_name(name_or_rgb)
        @rgb = RGB.new *name2rgb(@name)
      when Array
        @rgb = RGB.new *validate_rgb(name_or_rgb)
        @name = rgb2name(@rgb.to_a)
      else
        raise ArgumentError, "'#{name_or_rgb}' is wrong argument. Only colorname and RGB value are acceptable"
      end
    end

    def to_s
      rgb.to_s
    end

    def hex
      @hex ||= rgb2hex(rgb.to_a)
    end

    def hsb
      @hsb ||= HSB.new *rgb2hsb(rgb.to_a)
    end
    alias :hsv :hsb

    %w(red green blue).each_with_index do |c, i|
      define_method(c) { rgb[i] }
    end

    %w(hue sat bright).each_with_index do |n, i|
      define_method(n) { hsb[i] }
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