module Colorable
	class RGBRangeError < StandardError; end
	class RGB
		attr_accessor :rgb, :r, :g, :b
		def initialize(r=0,g=0,b=0)
			@r, @g, @b = @rgb = validate_rgb(r, g, b)
		end
		alias :red :r
		alias :green :g
		alias :blue :b
		
		def to_a
			rgb
		end

		def +(args)
			new_rgb = self.rgb.zip(args).map { |x, y| x + y }
			self.class.new *validate_rgb(*new_rgb)
		end
		
		private
		def validate_rgb(r, g, b)
			[r, g, b].tap do |rgb|
				raise RGBRangeError unless rgb.all? { |c| c.between?(0, 255) }
			end
		end
	end
end