module Colorable
  class Color
    include Comparable

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
      modes = [_rgb, _hsb, _name, _hex]
      @mode = modes.detect { |m| m.class.to_s.match /#{mode}/i } || begin
                raise ArgumentError, "Invalid mode given"
              end
    end

    def to_s
      @mode.to_s
    end

    def inspect
      "#<%s '%s<%s/%s/%s>'>" % [self.class, _name, _rgb, _hsb, _hex]
    end

    # Returns information of the color object
    def info
      {
        name: name,
        rgb: rgb,
        hsb: hsb,
        hex: hex,
        mode: mode,
        dark: dark?
      }
    end

    def _name
      @name
    end

    def _rgb
      @rgb
    end

    def _hex
      @hex ||= HEX.new _rgb.to_hex
    end

    def _hsb
      @hsb ||= HSB.new *_rgb.to_hsb
    end

    def name
      _name.to_s
    end

    def hex
      _hex.to_s
    end

    def rgb
      _rgb.to_a
    end

    def hsb
      _hsb.to_a
    end
    alias :hsv :hsb

    %w(red green blue).each do |c|
      define_method(c) { _rgb.send c }
    end

    %w(hue sat bright).each do |c|
      define_method(c) { _hsb.send c }
    end

    def <=>(other)
      if [self.name, other.name].any?(&:empty?)
        self.rgb <=> other.rgb
      else
        self.name <=> other.name
      end
    end

    @@colorset = {}
    # Returns a next color object in X11 colors.
    # The color sequence is determined by its color mode.
    def next(n=1)
      @@colorset[mode] ||= Colorable::Colorset.new(order: mode)
      idx = @@colorset[mode].find_index(self)
      @@colorset[mode].at(idx+n).tap{|c| c.mode = mode } if idx
    end
    alias :succ :next

    # Returns a previous color object in X11 colors.
    # The color sequence is determined by its color mode.
    def prev(n=1)
      self.next(-n)
    end

    def dark?
      !!DARK_COLORS.detect { |d| d == self.name }
    end

    # Color addition
    #
    # +other+ can be:
    #   Color object: apply minimum compositing with its RGBs.
    #   Array of values or Integer: addiction applies based on its color mode.
    def +(other)
      case other
      when Color
        new_by_composed_rgb(:+, other)
      else
        self.class.new @mode + other
      end
    end

    # Color subtruction
    #
    # +other+ can be:
    #   Color object: apply maximum compositing with its RGBs.
    #   Array of values or Integer: subtruction applies based on its color mode.
    def -(other)
      case other
      when Color
        new_by_composed_rgb(:-, other)
      else
        self.class.new @mode - other
      end
    end

    # Color multiplication
    #
    # +other+ should be a Color object.
    # It applies multiply compositing with its RGBs.
    def *(other)
      new_by_composed_rgb(:*, other)
    end

    # Color division
    #
    # +other+ should be a Color object.
    # It applies screen compositing with its RGBs.
    def /(other)
      new_by_composed_rgb(:/, other)
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

    def new_by_composed_rgb(op, other)
      rgb = self._rgb.send(op, other._rgb)
      self.class.new(rgb).tap { |c| c.mode = self.mode }
    end
  end
end
