module Colorable
	class ColorSpace
    include Colorable::Converter
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

		def coerce(arg)
			[self, arg]
		end

		def to_s
			name = "#{self.class}"[/\w+$/].downcase
      "#{name}(%i,%i,%i)" % to_a
		end

		private
    def validate(pattern, data)
      case Array(data)
      when Pattern[*Array(pattern)] then data
      else
        raise ArgumentError, "'#{data}' is invalid for a #{self.class} value"
      end
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
			new_rgb =
				case arg
				when Fixnum
					self.rgb.zip([arg] * 3).map { |x, y| (x + y) % 256 }
				when Array
					raise ArgumentError, "Must be three numbers contained" unless arg.size==3
					self.rgb.zip(arg).map { |x, y| (x + y) % 256 }
        when RGB
          self.rgb.zip(arg.rgb).map(&:min)
				else
					raise ArgumentError, "Accept a RGB objcet, Array of three numbers or a Fixnum"
				end
			self.class.new *new_rgb
		end

    def -(arg)
      case arg
      when RGB
        new_rgb = self.rgb.zip(arg.rgb).map(&:max)
  			self.class.new *new_rgb
      else
        super
      end
    end

		def to_name
			rgb2name(self.to_a)
		end

		def to_hsb
			rgb2hsb(self.to_a)
		end

		def to_hex
			rgb2hex(self.to_a)
		end

		private
    def validate_rgb(rgb)
      validate([0..255, 0..255, 0..255], rgb)
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
		undef :coerce

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
			new_hsb = self.hsb.zip(arg, [361, 101, 101]).map { |x, y, div| (x + y) % div }
			self.class.new *new_hsb
		end

		def to_name
			rgb2name(self.to_rgb)
		end

		def to_rgb
			hsb2rgb(self.to_a)
		end

		def to_hex
			rgb2hex(self.to_rgb)
		end

		private
    def validate_hsb(hsb)
      validate([0..359, 0..100, 0..100], hsb)
    end
	end

	class HEX < ColorSpace
		attr_reader :hex
		def initialize(hex='#FFFFFF')
			@hex = validate_hex(hex)
		end
		alias :to_s :hex

		def to_a
			@hex.unpack('A1A2A2A2').drop(1)
		end

		def +(arg)
			build_hex_with(:+, arg)
		end

		def -(arg)
			build_hex_with(:-, arg)
		end

		def to_rgb
			hex2rgb(self.to_s)
		end

		def to_hsb
			rgb2hsb(self.to_rgb)
		end

		def to_name
			rgb2name(self.to_rgb)
		end

    private
    def validate_hex(hex)
    	hex = hex.join if hex.is_a?(Array)
      validate(/^#[0-9A-F]{6}$/i, hex_norm(hex))
    end

    def hex_norm(hex)
    	hex = hex.to_s.sub(/^#/, '').upcase
    	 				 .sub(/^([0-9A-F])([0-9A-F])([0-9A-F])$/, '\1\1\2\2\3\3')
    	"##{hex}"
    end

    def rgb2hex(rgb)
      hex = rgb.map do |val|
        val.to_s(16).tap { |h| break "0#{h}" if h.size==1 }
      end
      '#' + hex.join.upcase
    end

    def hex2rgb(hex)
      _, *hex = hex.unpack('A1A2A2A2')
      hex.map { |val| val.to_i(16) }
    end

    def build_hex_with(op, arg)
    	_rgb =
				case arg
				when Fixnum
					[arg] * 3
				when String
					hex2rgb(validate_hex arg)
				else
					raise ArgumentError, "Accept only a Hex string or a Fixnum"
				end	
			rgb = hex2rgb(self.hex).zip(_rgb).map { |x, y| (x.send(op, y)) % 256 }
			self.class.new rgb2hex(rgb)
    end
	end

	class NAME < ColorSpace
		attr_accessor :name
		attr_reader :sym
		def initialize(name)
			@name = find_name(name)
			@sym = nil
		end

		alias :to_s :name

		def sym(sep='_')
			@name.gsub(/\s/, sep).downcase.intern if @name
		end

		def dark?
      DARK_COLORS.detect { |d| d == self.name }
		end

		def <=>(other)
			self.name <=> other.name
		end

		def +(n)
			raise ArgumentError, 'Only accept a Fixnum' unless n.is_a?(Fixnum)
			pos = COLORNAMES.find_index{|n,_| n==self.name} + n
			self.class.new COLORNAMES.at(pos % COLORNAMES.size)[0]
		end

		def -(n)
			raise ArgumentError, 'Only accept a Fixnum' unless n.is_a?(Fixnum)
			self + -n
		end

		def coerce(arg)
			[self, arg]
		end

		def to_rgb
			name2rgb(self.to_s)
		end

		def to_hsb
			rgb2hsb(self.to_rgb)
		end

		def to_hex
			rgb2hex(self.to_rgb)
		end

		private
		def find_name(name)
			COLORNAMES.map(&:first).detect { |c|
        [c, name].same? { |str| "#{str}".gsub(/[_\s]/,'').downcase }
			} || begin
				raise ArgumentError, "'#{name}' is not in X11 colorset."
			end
		end	
	end
end  
