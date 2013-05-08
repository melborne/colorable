module Colorable
  class Color
    class NameError < StandardError; end
    include Comparable
    attr_reader :name, :rgb

    # +arg+ can be Colorname, Array of RGB values, also RGB, HSB or NAME object.
    # Each Color object has output mode, which is :NAME, :RGB or :HSB.
    def initialize(arg)
      @name, @rgb, @hsb, @hex, @mode = set_variables(arg)
    end

    def mode
      "#{@mode.class}"[/\w+$/].intern
    end

    # Set output mode.
    def mode=(mode)
      @mode = 
        [rgb, hsb, name].detect { |c| c.class.to_s.match /#{mode}/i } || begin
          raise ArgumentError, "Only accept :NAME, :RGB or :HSB"
        end
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
      @hex ||= HEX.new rgb.to_hex
    end

    def hsb
      @hsb ||= HSB.new *rgb.to_hsb
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
    def set_variables(arg)
      case arg
      when String, Symbol
        begin
          hex = HEX.new(arg)
          name = hex.to_name
          rgb = hex.to_rgb
          hsb = nil
          mode = hex
        rescue ArgumentError
          name = validate_name(arg)
          rgb = RGB.new *name.to_rgb
          hsb = nil
          hex = nil
          mode = name
        end
      when Array
        rgb = RGB.new *arg
        name = NAME.new(rgb.to_name) rescue nil
        hsb = nil
        hex = nil
        mode = rgb
      when RGB
        rgb = arg
        name = NAME.new(rgb.to_name) rescue nil
        hsb = nil
        hex = nil
        mode = rgb
      when HSB
        hsb = arg
        rgb = RGB.new *hsb.to_rgb
        name = NAME.new(rgb.to_name) rescue nil
        hex = nil
        mode = hsb
      when NAME
        name = arg
        rgb = RGB.new *name.to_rgb
        hsb = nil
        hex = nil
        mode = name
      else
        raise ArgumentError, "'#{arg}' is wrong argument. Colorname, Array of RGB values, also RGB, HSB or NAME object are acceptable"
      end
      return name, rgb, hsb, hex, mode
    end

    def validate_name(name)
      NAME.new(name).tap do |res|
        raise NameError, "'#{name}' is not a valid colorname" unless res.name
      end
    end
  end
end