# Colorable

A simple color handler which provide a conversion between colorname, RGB, HSB and HEX. It also provides a colorset which can be sorted by above color units.

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

    # Accept X11 color names
    c = Colorable::Color.new(:green)
    c # => rgb(0,255,0)
    c.name # => "Green"
    c.hsb # => [120, 100, 100]
    c.hex # => "#00FF00"

    # or RGB
    c2 = Colorable::Color.new([240, 248, 255])
    c2 # => rgb(240,248,255)
    c2.name # => "Alice Blue"
    c2.rgb # => [240, 248, 255]
    c2.hsb # => [208, 6, 100]
    c2.hex # => "#F0F8FF"

Create a colorset object:

    # Default colorset sequence is by its color name order.
    cs = Colorable::Colorset.new
    cs.at # => rgb(240,248,255)
    10.times.map { cs.next.name } # => ["Antique White", "Aqua", "Aquamarine", "Azure", "Beige", "Bisque", "Black", "Blanched Almond", "Blue", "Blue Violet"]

    # Using Colorset#[], the order of the sequence is specified.
    cs2 = Colorable::Colorset[:hsb]
    cs2.at # => rgb(0,0,0)
    10.times.map { cs2.next.hsb } # => [[0, 0, 41], [0, 0, 50], [0, 0, 66], [0, 0, 75], [0, 0, 75], [0, 0, 83], [0, 0, 86], [0, 0, 96], [0, 0, 100], [0, 2, 100]]


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
