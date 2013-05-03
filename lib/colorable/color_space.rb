module Colorable
	class ColorSpace
		class RangeError < StandardError; end
		include Comparable

		def <=>(other)
			self.to_a <=> other.to_a
		end

	  def move_to_top(idx)
	    arr = self.to_a
	    arr.insert 0, arr.delete_at(idx)
	  end

	  def +(arg)
	  	raise "Subclass must implement it"
	  end

		def -(arg)
			arg = arg.is_a?(Fixnum) ? -arg : arg.map(&:-@)
			self + arg
		end

		def to_s
			name = "#{self.class}"[/\w+$/].downcase
      "#{name}(%i,%i,%i)" % to_a
		end

		private
		def validate_colorvalue(val, range)
			raise RangeError, "the value must within #{range}" unless range.cover?(val)
			val
		end
	end

	class RGB < ColorSpace
		attr_accessor :rgb, :r, :g, :b
		def initialize(r=0,g=0,b=0)
			@r, @g, @b = @rgb = validate_rgb([r, g, b])
		end
		alias :red :r
		alias :green :g
		alias :blue :b
		alias :to_a :rgb

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
			self.class.new *validate_rgb(new_rgb)
		end

		def coerce(arg)
			[self, arg]
		end
		
		private
		def validate_rgb(rgb)
			rgb.tap do |rgb|
				rgb.map { |c| validate_colorvalue c, 0..255 }
			end
		end
	end

	class HSB < ColorSpace
		attr_accessor :hsb, :h, :s, :b
		def initialize(h=0,s=0,b=0)
			@h, @s, @b = @hsb = validate_hsb([h, s, b])
		end
		alias :hue :h
		alias :sat :s
		alias :bright :b
		alias :to_a :hsb

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
			self.class.new *validate_hsb(new_hsb)
		end

		private
		def validate_hsb(hsb)
			hsb.tap do |hsb|
				hsb.zip([0...360, 0..100, 0..100])
				   .map { |c, r| validate_colorvalue c, r }
			end
		end
	end

	class NAME
		attr_accessor :name
		attr_reader :sym
		def initialize(name)
			@name = find_name(name)
			@sym = nil
		end

		alias :to_s :name

		def sym
			@name.gsub(/\s/, '_').downcase.intern if @name
		end

		def dark?
      DARK_COLORS.detect { |d| d == self.name }
		end

		def <=>(other)
			self.name <=> other.name
		end

		private
		def find_name(name)
      COLORNAMES.detect do |label, _|
        [label, name].same? { |str| "#{str}".gsub(/[_\s]/,'').downcase }
      end.tap {|label, _| break label if label }
		end	
	end
end