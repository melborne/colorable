class Colorable::Color
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