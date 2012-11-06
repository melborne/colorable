module Colorable
  class Color
    class ColorNameError < StandardError; end
    include Colorable::Converter
    attr_reader :name, :rgb

    def initialize(name_or_rgb)
      @name, @rgb, @hex, @hsb, @esc = nil
      case name_or_rgb
      when String, Symbol
        @name = varidate_name(name_or_rgb)
        @rgb = name2rgb(@name)
      when Array
        @rgb = validate_rgb(name_or_rgb)
        @name = rgb2name(@rgb)
      else
        raise ArgumentError, "'#{name_or_rgb}' is wrong argument. Only colorname and RGB value are acceptable"
      end
    end

    def to_s
      "rgb(%i,%i,%i)" % rgb
    end

    def hex
      @hex ||= rgb2hex(rgb)
    end

    def hsb
      @hsb ||= rgb2hsb(rgb)
    end
    alias :hsv :hsb

    %w(red green blue).each_with_index do |c, i|
      define_method(c) { rgb[i] }
    end

    %w(hue sat bright).each_with_index do |n, i|
      define_method(n) { hsb[i] }
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