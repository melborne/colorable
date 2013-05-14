require_relative 'spec_helper'

include Colorable
describe RGB do
  describe ".new" do
    context "without arguments" do
      subject { RGB.new }
      its(:to_a) { should eql [0, 0, 0] }
      its(:rgb) { should eql [0, 0, 0] }
      its(:red) { should eql 0 }
      its(:green) { should eql 0 }
      its(:blue) { should eql 0 }
    end

    context "with arguments" do
      subject { RGB.new 100, 255, 255 }
      its(:to_a) { should eql [100, 255, 255] }
      its(:rgb) { should eql [100, 255, 255] }
      its(:red) { should eql 100 }
      its(:green) { should eql 255 }
      its(:blue) { should eql 255 }
    end

    context "pass out of RGB range" do
      it "raise ArgumentError" do
        expect { RGB.new(0, 0, 256) }.to raise_error ArgumentError
        expect { RGB.new(-10, 0, 255) }.to raise_error ArgumentError
        expect { RGB.new(256, 256, 256) }.to raise_error ArgumentError
      end
    end
  end

  describe "#+" do
    context "pass an array of numbers" do
      before(:all) { @rgb = RGB.new(100, 100, 100) }
      subject { @rgb + [0, 50, 100] }
      its(:rgb) { should eql [100, 150, 200] }
      it "keep original same" do
        @rgb.rgb.should eql [100, 100, 100]
      end
    end

    context "when '+' makes out of RGB range or rack of numbers" do
      it "raise ArgumentError" do
        expect { RGB.new(100, 100, 100) + [0, 150] }.to raise_error ArgumentError
      end

      it "not raise ArgumentError" do
        expect { RGB.new(100, 100, 100) + [0, 50, 200] }.not_to raise_error ArgumentError
        expect { RGB.new(100, 100, 100) + [0, -150, 0] }.not_to raise_error ArgumentError
      end
    end

    context "pass a Fixnum" do
      before(:all) { @rgb = RGB.new(100, 100, 100) }
      it { (@rgb + 50).rgb.should eql [150, 150, 150] }
      it "not raise ArgumentError" do
        expect { @rgb + 160 }.not_to raise_error ArgumentError
      end
    end

    context "coerce make Fixnum#+ accept rgb object" do
      it { (10 + RGB.new(100, 100, 100)).rgb.should eql [110, 110, 110] }
    end

    context "pass a RGB object" do
      before(:each) do
        @a = RGB.new(100, 100, 255)
        @b = RGB.new(255, 100, 100)
        @c = RGB.new(100, 255, 100)
      end
      it { (@a + @b).rgb.should eql [255, 200, 255] }
      it { (@b + @c).rgb.should eql [255, 255, 200] }
      it { (@a + @c).rgb.should eql [200, 255, 255] }
      it { (@a + @b + @c).rgb.should eql [255, 255, 255] }
    end
  end

  describe "#-" do
    context "pass an array of numbers" do
      before(:all) { @rgb = RGB.new(100, 100, 100) }
      subject { @rgb - [0, 50, 100] }
      its(:rgb) { should eql [100, 50, 0] }
      it "keep original same" do
        @rgb.rgb.should eql [100, 100, 100]
      end
    end

    context "when '-' makes out of RGB range" do
      it "not raise ArgumentError" do
        expect { RGB.new(100, 100, 100) - [0, 50, 200] }.not_to raise_error ArgumentError
        expect { RGB.new(100, 100, 100) - [0, -250, 0] }.not_to raise_error ArgumentError
      end
    end

    context "pass a Fixnum" do
      before(:all) { @rgb = RGB.new(100, 100, 100) }
      it { (@rgb - 50).rgb.should eql [50, 50, 50] }
      it "not raise ArgumentError" do
        expect { @rgb - 160 }.not_to raise_error ArgumentError
      end
    end

    context "pass a RGB object" do
      before(:each) do
        @a = RGB.new(100, 100, 255)
        @b = RGB.new(255, 100, 100)
        @c = RGB.new(100, 255, 100)
      end
      it { (@a - @b).rgb.should eql [100, 0, 100] }
      it { (@b - @c).rgb.should eql [100, 100, 0] }
      it { (@a - @c).rgb.should eql [0, 100, 100] }
      it { (@a - @b - @c).rgb.should eql [0, 0, 0] }
    end
  end

  describe "#*" do
    context "pass a RGB object" do
      before(:each) do
        @a = RGB.new(100, 100, 255)
        @b = RGB.new(255, 100, 100)
        @c = RGB.new(100, 255, 100)
      end
      it { (@a * @b).rgb.should eql [100, 39, 100] }
      it { (@b * @c).rgb.should eql [100, 100, 39] }
      it { (@a * @c).rgb.should eql [39, 100, 100] }
      it { (@a * @b * @c).rgb.should eql [39, 39, 39] }
    end
  end

  describe "#/" do
    context "pass a RGB object" do
      before(:each) do
        @a = RGB.new(100, 100, 255)
        @b = RGB.new(255, 100, 100)
        @c = RGB.new(100, 255, 100)
      end
      it { (@a / @b).rgb.should eql [255, 161, 255] }
      it { (@b / @c).rgb.should eql [255, 255, 161] }
      it { (@a / @c).rgb.should eql [161, 255, 255] }
      it { (@a / @b / @c).rgb.should eql [255, 255, 255] }
    end
  end

  describe "#to_s" do
    it { RGB.new(0, 50, 100).to_s.should eql "rgb(0,50,100)"}
  end

  describe "#to_name" do
    it { RGB.new(240, 248, 255).to_name.should eql 'Alice Blue' }
  end

  describe "#to_hsb" do
    it { RGB.new(240, 248, 255).to_hsb.should eql [208, 6, 100] }
  end

  describe "#to_hex" do
    it { RGB.new(240, 248, 255).to_hex.should eql '#F0F8FF' }
  end
end

describe HSB do
  describe ".new" do
    context "without arguments" do
      subject { HSB.new }
      its(:to_a) { should eql [0, 0, 0] }
      its(:hsb) { should eql [0, 0, 0] }
      its(:hue) { should eql 0 }
      its(:sat) { should eql 0 }
      its(:bright) { should eql 0 }
    end

    context "with arguments" do
      subject { HSB.new 300, 70, 90 }
      its(:to_a) { should eql [300, 70, 90] }
      its(:hsb) { should eql [300, 70, 90] }
      its(:hue) { should eql 300 }
      its(:sat) { should eql 70 }
      its(:bright) { should eql 90 }
    end

    context "pass out of HSB range" do
      it "raise ArgumentError" do
        expect { HSB.new(0, 0, 120) }.to raise_error ArgumentError
        expect { HSB.new(360, 0, 80) }.to raise_error ArgumentError
        expect { HSB.new(0, -10, 0) }.to raise_error ArgumentError
      end
    end
  end

  describe "#+" do
    context "pass an array of numbers" do
      before(:all) { @hsb = HSB.new(300, 70, 90) }
      subject { @hsb + [0, 5, 10] }
      its(:hsb) { should eql [300, 75, 100] }
      it "keep original same" do @hsb.hsb.should eql [300, 70, 90] end
    end

    context "when '+' makes out of HSB range or rack of numbers" do
      it "raise ArgumentError" do
        expect { HSB.new(300, 70, 90) + [0, 5] }.to raise_error ArgumentError
        expect { HSB.new(300, 70, 90) + 5 }.to raise_error ArgumentError
      end

      it "not raise ArgumentError" do
        expect { HSB.new(300, 70, 90) + [60, 50, 0] }.not_to raise_error ArgumentError
        expect { HSB.new(300, 70, 90) + [0, 0, -100] }.not_to raise_error ArgumentError
      end
    end
  end

  describe "#-" do
    context "pass an array of numbers" do
      before(:all) { @hsb = HSB.new(300, 70, 90) }
      subject { @hsb - [0, 5, 10] }
      its(:hsb) { should eql [300, 65, 80] }
      it "keep original same" do @hsb.hsb.should eql [300, 70, 90] end
    end

    context "when '-' makes out of HSB range" do
      it "not raise ArgumentError" do
        expect { HSB.new(300, 7, 90) - [305, 0, 10] }.not_to raise_error ArgumentError
        expect { HSB.new(300, 70, 90) - [0, -35, 0] }.not_to raise_error ArgumentError
      end
    end
  end

  describe "#to_s" do
    it { HSB.new(0, 50, 100).to_s.should eql "hsb(0,50,100)"}
  end

  describe "#to_name" do
    it { HSB.new(208, 6, 100).to_name.should eql 'Alice Blue' }
  end

  describe "#to_rgb" do
    it { HSB.new(208, 6, 100).to_rgb.should eql [240, 248, 255] }
  end

  describe "#to_hex" do
    it { HSB.new(208, 6, 100).to_hex.should eql '#F0F8FF' }
  end
end

describe NAME do
  describe ".new" do
    context "with valid name" do
      subject { NAME.new :alice_blue } 
      its(:to_s) { should eql 'Alice Blue' }
      its(:name) { should eql 'Alice Blue' }
      its(:sym) { should eql :alice_blue }
    end

    context "with invalid name" do
      it "raise ArgumentError" do
        expect { NAME.new :abc_color }.to raise_error ArgumentError
      end
    end
  end

  describe "dark?" do
    it { NAME.new(:navy).dark?.should be_true }
    it { NAME.new(:alice_blue).dark?.should be_false }
  end

  describe "#+" do
    context "pass an irregal argument" do
      it "raise ArgumentError" do
        expect { NAME.new(:alice_blue) + [0, 150, 100] }.to raise_error ArgumentError
      end
    end

    context "pass a Fixnum" do
      before(:all) { @name = NAME.new(:alice_blue) }
      it { (@name + 1).name.should eql 'Antique White' }
      it { (@name + 2).name.should eql 'Aqua' }
    end

    context "coerce make Fixnum#+ accept name object" do
      it { (1 + NAME.new(:alice_blue)).to_s.should eql 'Antique White' }
    end
  end

  describe "#-" do
    context "pass an irregal argument" do
      it "raise ArgumentError" do
        expect { NAME.new(:alice_blue) - [0, 150, 100] }.to raise_error ArgumentError
      end
    end

    context "pass a Fixnum" do
      before(:all) { @name = NAME.new(:alice_blue) }
      it { (@name - 1).name.should eql 'Yellow Green' }
      it { (@name - 2).name.should eql 'Yellow' }
    end

    context "coerce make Fixnum#+ accept name object" do
      it { (1 - NAME.new(:alice_blue)).to_s.should eql 'Yellow Green' }
    end
  end

  describe "#to_rgb" do
    it { NAME.new('Alice Blue').to_rgb.should eql [240, 248, 255] }
  end

  describe "#to_hsb" do
    it { NAME.new('Alice Blue').to_hsb.should eql [208, 6, 100] }
  end

  describe "#to_hex" do
    it { NAME.new('Alice Blue').to_hex.should eql '#F0F8FF' }
  end
end

describe HEX do
  describe ".new" do
    context "without arguments" do
      subject { HEX.new }
      its(:to_s) { should eql '#FFFFFF' }
      its(:hex) { should eql '#FFFFFF' }
      its(:to_a) { should eql ['FF', 'FF', 'FF'] }
    end

    context "with arguments" do
      it { HEX.new('#FFFF00').to_s.should eql '#FFFF00' }
      it { HEX.new('#ffff00').to_s.should eql '#FFFF00' }
      it { HEX.new('FFFF00').to_s.should eql '#FFFF00' }
      it { HEX.new('#ff0').to_s.should eql '#FFFF00' }
      it { HEX.new(['FF', 'FF', '00']).to_s.should eql '#FFFF00' }
    end

    context "pass out of HEX range" do
      it "raise ArgumentError" do
        expect { HEX.new('#FFGG00') }.to raise_error ArgumentError
        expect { HEX.new('aaxxxx') }.to raise_error ArgumentError
        expect { HEX.new(['FF', 'FF', 00]) }.to raise_error ArgumentError
      end
    end
  end

  describe "#+" do
    context "pass a HEX string" do
      before(:all) { @hex = HEX.new('#FF0000') }
      it { (@hex + '#00FFCC').hex.should eql '#FFFFCC'}
      it { (@hex + '#00ffcc').hex.should eql '#FFFFCC'}
      it { (@hex + '00FFCC').hex.should eql '#FFFFCC'}
      it { (@hex + '#0FC').hex.should eql '#FFFFCC'}
      it "keep original" do
        @hex.hex.should eql '#FF0000'
      end
    end

    context "out of HEX range or Array" do
      it "not raise ArgumentError" do
        expect { HEX.new('#FF0000') + '#010000' }.not_to raise_error ArgumentError
      end
      
      it "raise ArgumentError" do
        expect { HEX.new('#FF0000') + '#00ffgg' }.to raise_error ArgumentError
        expect { HEX.new('#000000') + [0, 50, 100] }.to raise_error ArgumentError
      end
    end

    context "pass a Fixnum" do
      before(:all) { @hex = HEX.new('#000000') }
      it { (@hex + 255).hex.should eql '#FFFFFF' }
      it "not raise ArgumentError" do
        expect { @hex + 260 }.not_to raise_error ArgumentError
      end
    end

    context "coerce make Fixnum#+ accept hex object" do
      it { (255 + HEX.new('#000000')).hex.should eql '#FFFFFF' }
    end
  end

  describe "#-" do
    context "pass a HEX string" do
      before(:all) { @hex = HEX.new('#00FFFF') }
      it { (@hex - '#00FFCC').hex.should eql '#000033'}
      it { (@hex - '#00ffcc').hex.should eql '#000033'}
      it { (@hex - '00FFCC').hex.should eql '#000033'}
      it { (@hex - '#0FC').hex.should eql '#000033'}
      it "keep original" do
        @hex.hex.should eql '#00FFFF'
      end
    end

    context "out of HEX range or Array" do
      it "not raise ArgumentError" do
        expect { HEX.new('#FF0000') - '#000100' }.not_to raise_error ArgumentError
        expect { HEX.new('#FF0000') - '#0000cc' }.not_to raise_error ArgumentError
      end

      it "raise ArgumentError" do
        expect { HEX.new('#000000') - [0, 50, 100] }.to raise_error ArgumentError
      end
    end

    context "pass a Fixnum" do
      before(:all) { @hex = HEX.new('#FFFFFF') }
      it { (@hex - 255).hex.should eql '#000000' }
      it "not raise ArgumentError" do
        expect { @hex + 260 }.not_to raise_error ArgumentError
      end
    end

    context "coerce make Fixnum#+ accept hex object" do
      it { (255 - HEX.new('#FFFFFF')).hex.should eql '#000000' }
    end
  end

  describe "#to_s" do
    it { HEX.new('#F0F8FF').to_s.should eql '#F0F8FF' }
  end

  describe "#to_rgb" do
    it { HEX.new('#F0F8FF').to_rgb.should eql [240, 248, 255] }
  end

  describe "#to_hsb" do
    it { HEX.new('#F0F8FF').to_hsb.should eql [208, 6, 100] }
  end

  describe "#to_name" do
    it { HEX.new('#F0F8FF').to_name.should eql 'Alice Blue' }
  end
end
