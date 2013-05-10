# Colorable

Colorable is a color handler written in Ruby which include Color and Colorset classes.
A color object provide a conversion between X11 colorname, RGB, HSB and HEX or other manipulations. a colorset object represent X11 colorset which can be manipulated like enumerable object.

## Installation

Add this line to your application's Gemfile:

    gem 'colorable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install colorable

## Usage

Create a color object:

    require "colorable"
    include Colorable

    # with a X11 colorname
    c = Color.new :lime_green
    c.to_s #=> "Lime Green"
    c.rgb.to_a #=> [50, 205, 50]
    c.hsb.to_a #=> [120, 76, 80]
    c.hex.to_s #=> "#32CD32"
    c.dark? #=> false

    # with Array of RGB values
    c = Color.new [50, 205, 50]
    c.to_s #=> "rgb(50,205,50)"
    c.name.to_s #=> "Lime Green"
    c.hsb.to_a #=> [120, 76, 80]
    c.hex.to_s #=> "#32CD32"

    # with a HEX string
    c = Color.new '#32CD32'
    c.to_s #=> "#32CD32"

    # with a RGB, HSB or HEX object
    c = Color.new RGB.new(50, 205, 50)
    c = Color.new HSB.new(120, 76, 80)
    c = Color.new HEX.new('#32CD32')

Manipulate color object:

    c = Color.new :lime_green

    c.to_s #=> "Lime Green"
    c.rgb.to_a #=> [50, 205, 50]
    c.hsb.to_a #=> [120, 76, 80]
    c.hex.to_s #=> "#32CD32"
    c.dark? #=> false

    # info returns information of the color
    c.info #=> {:NAME=>"Lime Green", :RGB=>[50, 205, 50], :HSB=>[120, 76, 80], :HEX=>"#32CD32", :MODE=>:NAME, :DARK=>false}

    # next, prev returns next, prev color object in X11 color sequence
    c.next.to_s #=> "Linen"
    c.next(2).to_s #=> "Magenta"
    c.prev.to_s #=> "Lime"
    c.prev(2).to_s #=> "Light Yellow"

    # +, - returns incremented or decremented color object
    (c + 1).to_s #=> "Linen"
    (c + 2).to_s #=> "Magenta"
    (c - 1).to_s #=> "Lime"
    (c - 2).to_s #=> "Light Yellow"

Color object has a mode which represent output mode of the color. Behaviours of `#to_s`, `next`, `prev`, `+`, `-` will be changed based on the mode. You can change the mode with `#mode=` between :NAME, :RGB, :HSB, :HEX.

    c = Color.new 'Lime Green'
    c.mode = :NAME
    c.to_s #=> "Lime Green"
    c.next.to_s #=> "Linen"

    c.mode = :RGB
    c.to_s #=> "rgb(50,205,50)"
    c.next.to_s #=> "rgb(60,179,113)"
    c.next.name.to_s #=> "Medium Sea Green"
    (c + 10).to_s #=> "rgb(60,215,60)"
    (c + [0, 50, 100]).to_s #=> "rgb(50, 255, 150)"

Shortcut for creating a color object with #to_color of String, Symbol and Array:

    c = "Lime Green".to_color
    c.class #=> Colorable::Color

    c = :lime_green.to_color
    c.class #=> Colorable::Color

    c = "#32CD32".to_color
    c.class #=> Colorable::Color

    c = [50, 205, 50].to_color
    c.class #=> Colorable::Color

Create a X11 colorset object:

    include Colorable

    cs = Colorset.new #=> #<Colorset 0/144 pos='Alice Blue/rgb(240,248,255)/hsb(208,6,100)'>

    # with option
    cs = Colorset.new(order: :RGB) #=> #<Colorset 0/144 pos='Black/rgb(0,0,0)/hsb(0,0,0)'>
    cs = Colorset.new(order: :HSB, dir: :-) #=> #<Colorset 0/144 pos='Light Pink/rgb(255,182,193)/hsb(352,29,100)'>

Manupilate colorset:

    cs = Colorset.new
    cs.size #=> 144
    cs.at.to_s #=> "Alice Blue"
    cs.at(1).to_s #=> "Antique White"
    cs.at(2).to_s #=> "Aqua"

    # next(prev) methods moves cursor position
    cs.next.to_s #=> "Antique White"
    cs.at.to_s #=> "Antique White"
    cs.next.to_s #=> "Aqua"
    cs.at.to_s #=> "Aqua"
    cs.rewind
    cs.at.to_s #=> "Alice Blue"

    cs.map(&:to_s).take(10) #=> ["Alice Blue", "Antique White", "Aqua", "Aquamarine", "Azure", "Beige", "Bisque", "Black", "Blanched Almond", "Blue"]

    cs.sort_by(&:rgb).map(&:to_s).take(10) #=> ["Black", "Navy", "Dark Blue", "Medium Blue", "Blue", "Dark Green", "Green2", "Teal", "Dark Cyan", "Deep Sky Blue"]

    cs.sort_by(&:hsb).map(&:to_s).take(10) #=> ["Black", "Dim Gray", "Gray2", "Dark Gray", "Gray", "Silver", "Light Gray", "Gainsboro", "White Smoke", "White"]


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
