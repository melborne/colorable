# Colorable

Colorable is a color handler written in Ruby, which has following functionalities;

    1. Color conversion: convertible between X11 colorname, HEX, RGB and HSB values.
    2. Color composition: a color object can be composible using math operators.
    3. Color enumeration: a color object can be enumerable within X11 colors.
    4. Color mode: a color object has a mode which represent output state of the color.

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

    # from a X11 colorname
    Color.new 'Alice Blue' # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>

    # from a HEX string
    Color.new '#F0F8FF' # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>

    # from RGB values
    Color.new [240, 248, 255] # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>

    # from a HSB object
    Color.new HSB.new(208, 6, 100) # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>

    # using #to_color methods

    'Alice Blue'.to_color # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>

    :alice_blue.to_color # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>

    '#f0f8ff'.to_color # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>

    [240, 248, 255].to_color # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>

    0xf0f8ff.to_color # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>


Color conversion:

    c = Color.new :alice_blue

    c.name # => "Alice Blue"
    c.rgb  # => [240, 248, 255]
    c.hsb  # => [208, 6, 100]
    c.hex  # => "#F0F8FF"
    c.dark?     # => false
    c.info # => {:name=>"Alice Blue", :rgb=>[240, 248, 255], :hsb=>[208, 6, 100], :hex=>"#F0F8FF", :mode=>:NAME, :dark=>false}

    [240, 248, 255].to_color.hex # => "#F0F8FF"
    [240, 248, 255].to_color.hsb # => [208, 6, 100]


Color composition:

    red = Color.new :red
    green = Color.new :green
    blue = Color.new :blue

    yellow = red + green
    yellow.info # => {:name=>"Yellow", :rgb=>[255, 255, 0], :hsb=>[60, 100, 100], :hex=>"#FFFF00", :mode=>:NAME, :dark=>false}

    red + blue # => #<Colorable::Color 'Fuchsia<rgb(255,0,255)/hsb(300,100,100)/#FF00FF>'>

    green + blue # => #<Colorable::Color 'Aqua<rgb(0,255,255)/hsb(180,100,100)/#00FFFF>'>

    red + green + blue # => #<Colorable::Color 'White<rgb(255,255,255)/hsb(0,0,100)/#FFFFFF>'>

    red - green # => #<Colorable::Color 'Black<rgb(0,0,0)/hsb(0,0,0)/#000000>'>
    red * green # => #<Colorable::Color 'Black<rgb(0,0,0)/hsb(0,0,0)/#000000>'>
    red / green # => #<Colorable::Color 'Yellow<rgb(255,255,0)/hsb(60,100,100)/#FFFF00>'>

Color enumeration:

    c = Color.new :alice_blue
    
    c.next # => #<Colorable::Color 'Antique White<rgb(250,235,215)/hsb(35,14,98)/#FAEBD7>'>
    c.next(10) # => #<Colorable::Color 'Blue Violet<rgb(138,43,226)/hsb(271,81,89)/#8A2BE2>'>

    c.prev # => #<Colorable::Color 'Yellow Green<rgb(154,205,50)/hsb(79,76,80)/#9ACD32>'>
    c.prev(10) # => #<Colorable::Color 'Teal<rgb(0,128,128)/hsb(180,100,50)/#008080>'>

    c + 1 # => #<Colorable::Color 'Antique White<rgb(250,235,215)/hsb(35,14,98)/#FAEBD7>'>
    c + 10 # => #<Colorable::Color 'Blue Violet<rgb(138,43,226)/hsb(271,81,89)/#8A2BE2>'>
    c - 1 # => #<Colorable::Color 'Yellow Green<rgb(154,205,50)/hsb(79,76,80)/#9ACD32>'>
    c - 10 # => #<Colorable::Color 'Teal<rgb(0,128,128)/hsb(180,100,50)/#008080>'>

    10.times.map { c = c.next }.map(&:name) # => ["Antique White", "Aqua", "Aquamarine", "Azure", "Beige", "Bisque", "Black", "Blanched Almond", "Blue", "Blue Violet"]


Color mode:

    c = Color.new :alice_blue
    c.mode # => :NAME
    c.to_s # => "Alice Blue"
    c.next # => #<Colorable::Color 'Antique White<rgb(250,235,215)/hsb(35,14,98)/#FAEBD7>'>
    c + 1 # => #<Colorable::Color 'Antique White<rgb(250,235,215)/hsb(35,14,98)/#FAEBD7>'>

    c.mode = :RGB
    c.to_s # => "rgb(240,248,255)"
    c.next # => #<Colorable::Color 'Honeydew<rgb(240,255,240)/hsb(120,6,100)/#F0FFF0>'>
    c + [15, -20, -74] # => #<Colorable::Color 'Moccasin<rgb(255,228,181)/hsb(39,29,100)/#FFE4B5>'>
    c - 20 # => #<Colorable::Color '<rgb(220,228,235)/hsb(208,6,92)/#DCE4EB>'>

    c.mode = :HSB # !> `*' interpreted as argument prefix
    c.to_s # => "hsb(208,6,100)"
    c.next # => #<Colorable::Color 'Slate Gray<rgb(112,128,144)/hsb(210,22,56)/#708090>'>
    c + [152, 94, 0] # => #<Colorable::Color 'Red<rgb(255,0,0)/hsb(0,100,100)/#FF0000>'>

    c.mode = :HEX
    c.to_s # => "#F0F8FF"
    c.next # => #<Colorable::Color 'Honeydew<rgb(240,255,240)/hsb(120,6,100)/#F0FFF0>'>
    c + 4 # => #<Colorable::Color '<rgb(244,252,3)/hsb(62,99,99)/#F4FC03>'>

Create a X11 Colorset object

        cs = Colorset.new # => #<Colorable::Colorset 0/144 pos='Alice Blue<rgb(240,248,255)/hsb(208,6,100)>'>

        # with option
        cs = Colorset.new(order: :RGB) # => #<Colorable::Colorset 0/144 pos='Black<rgb(0,0,0)/hsb(0,0,0)>'>
        cs = Colorset.new(order: :HSB, dir: :-) # => #<Colorable::Colorset 0/144 pos='Light Pink<rgb(255,182,193)/hsb(352,29,100)>'>


Manupilate colorset:

        cs = Colorset.new
        cs.size # => 144
        cs.at # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>
        cs.at.to_s # => "Alice Blue"
        cs.at(1).to_s # => "Antique White"
        cs.at(2).to_s # => "Aqua"

        # next(prev) methods moves cursor position
        cs.next.to_s # => "Antique White"
        cs.at.to_s # => "Antique White"
        cs.next.to_s # => "Aqua"
        cs.at.to_s # => "Aqua"
        cs.rewind
        cs.at.to_s # => "Alice Blue"

        cs.map(&:to_s).take(10) # => ["Alice Blue", "Antique White", "Aqua", "Aquamarine", "Azure", "Beige", "Bisque", "Black", "Blanched Almond", "Blue"]

        cs.sort_by(&:rgb).take(10).map(&:rgb) # => [[0, 0, 0], [0, 0, 128], [0, 0, 139], [0, 0, 205], [0, 0, 255], [0, 100, 0], [0, 128, 0], [0, 128, 128], [0, 139, 139], [0, 191, 255]]

        cs.sort_by(&:hsb).take(10).map(&:hsb) # => [[0, 0, 0], [0, 0, 41], [0, 0, 50], [0, 0, 66], [0, 0, 75], [0, 0, 75], [0, 0, 83], [0, 0, 86], [0, 0, 96], [0, 0, 100]]



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
