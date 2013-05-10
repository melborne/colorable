module Colorable
  class Color
    class NameError < StandardError; end
    include Comparable
    attr_reader :name, :rgb

    # Create a Color object which has several representations of a color.
    #
    # +arg+ can be:
    #   String or Symbol of color name
    #   String of HEX color
    #   Array of RGB values
    #   NAME, RGB, HSB, HEX objects
    #
    # Color object has output mode, which is determined by +arg+ type.
    def initialize(arg)
      @name, @rgb, @hsb, @hex, @mode = set_variables(arg)
    end

    # Returns a current output mode
    def mode
      "#{@mode.class}"[/\w+$/].intern
    end

    # Set output mode.
    def mode=(mode)
      modes = [rgb, hsb, name, hex]
      @mode = modes.detect { |m| m.class.to_s.match /#{mode}/i } || begin
                raise ArgumentError, "Invalid mode given"
              end
    end

    def to_s
      @mode.to_s
    end

    # Returns information of the color object
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
          name = NAME.new(hex.to_name) rescue nil
          rgb = RGB.new *hex.to_rgb
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
        raise ArgumentError, 'Invalid Array given' unless arg.size==3
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
      when HEX
        hex = arg
        name = NAME.new(hex.to_name) rescue nil
        rgb = RGB.new *hex.to_rgb
        hsb = nil
        mode = hex
      else
        raise ArgumentError
      end
      return name, rgb, hsb, hex, mode
    end

    def validate_name(name)
      NAME.new(name).tap do |res|
        raise NameError, "Invalid color name given" unless res.name
      end
    end
  end
end