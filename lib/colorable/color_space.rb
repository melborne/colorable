module Colorable
	class RGBRangeError < StandardError; end
	class RGB
		include Comparable
		attr_accessor :rgb, :r, :g, :b
		def initialize(r=0,g=0,b=0)
			@r, @g, @b = @rgb = validate_rgb(r, g, b)
		end
		alias :red :r
		alias :green :g
		alias :blue :b
		alias :to_a :rgb

		def to_s
      "rgb(%i,%i,%i)" % rgb
		end

		def <=>(other)
			self.to_a <=> other.to_a
		end

	  def move_to_top(idx)
	    arr = self.to_a
	    arr.insert 0, arr.delete_at(idx)
	  end

		# Pass Array of [r, g, b] or a Fixnum.
		# Returns new RGB object with added RGB.
		def +(arg)
			arg =
				case arg
				when Fixnum
					[arg] * 3
				when Array
					raise ArgumentError, "Must be three numbers contained" unless arg.size==3
					arg
				else
					raise ArgumentError, "Accept only Array of three numbers or a Fixnum"
				end
			new_rgb = self.rgb.zip(arg).map { |x, y| x + y }
			self.class.new *validate_rgb(*new_rgb)
		end

		def -(arg)
			arg = arg.is_a?(Fixnum) ? -arg : arg.map(&:-@)
			self + arg
		end

		def coerce(arg)
			[self, arg]
		end
		
		private
		def validate_rgb(r, g, b)
			[r, g, b].tap do |rgb|
				raise RGBRangeError unless rgb.all? { |c| c.between?(0, 255) }
			end
		end
	end

	class HSBRangeError < StandardError; end
	class HSB
		include Comparable
		attr_accessor :hsb, :h, :s, :b
		def initialize(h=0,s=0,b=0)
			@h, @s, @b = @hsb = validate_hsb(h, s, b)
		end
		alias :hue :h
		alias :sat :s
		alias :bright :b
		alias :to_a :hsb

		def to_a
			hsb
		end

		def to_s
      "hsb(%i,%i,%i)" % hsb
		end

		def <=>(other)
			self.to_a <=> other.to_a
		end

	  def move_to_top(idx)
	    arr = self.to_a
	    arr.insert 0, arr.delete_at(idx)
	  end

		# Pass Array of [h, s, b] or a Fixnum.
		# Returns new HSB object with added HSB.
		def +(arg)
			arg =
				case arg
				when Array
					raise ArgumentError, "Must be three numbers contained" unless arg.size==3
					arg
				else
					raise ArgumentError, "Accept only Array of three numbers"
				end
			new_hsb = self.hsb.zip(arg).map { |x, y| x + y }
			self.class.new *validate_hsb(*new_hsb)
		end

		def -(arg)
			arg = arg.is_a?(Fixnum) ? -arg : arg.map(&:-@)
			self + arg
		end
		
		private
		def validate_hsb(h, s, b)
			[h, s, b].tap do |hsb|
				range = [0...360, 0..100, 0..100]
				raise HSBRangeError unless hsb.zip(range).all? { |c, r| r.cover? c }
			end
		end
	end
end