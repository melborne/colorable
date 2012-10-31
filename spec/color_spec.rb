require_relative 'spec_helper'

describe Colorable::Color do
  let(:color) { Colorable::Color }
  describe ".new" do
    context "with a string" do
      context "of valid colorname" do
        it { color.new("Alice Blue").name.should eql "Alice Blue" }
        it { color.new("Khaki").name.should eql "Khaki" }
        it { color.new("Mint Cream").name.should eql "Mint Cream" }
        it { color.new("Thistle").name.should eql "Thistle" }
      end

      context "of valid name variations" do
        it { color.new("AliceBlue").name.should eql "Alice Blue" }
        it { color.new("aliceblue").name.should eql "Alice Blue" }
        it { color.new("aliceblue").name.should eql "Alice Blue" }
        it { color.new(:AliceBlue).name.should eql "Alice Blue" }
        it { color.new(:aliceblue).name.should eql "Alice Blue" }
        it { color.new(:alice_blue).name.should eql "Alice Blue" }
      end

      context "of invalid name" do
        it "raise an error" do
          expect { color.new("Alice-Blue") }.to raise_error color::ColorNameError
          expect { color.new("Alice") }.to raise_error color::ColorNameError
        end
      end
    end

    context "with an array" do
      context "of valid RGB value" do
        it { color.new([240, 248, 255]).rgb.should eql [240, 248, 255] }
        it { color.new([240, 230, 140]).rgb.should eql [240, 230, 140] }
        it { color.new([245, 255, 250]).rgb.should eql [245, 255, 250] }
        it { color.new([216, 191, 216]).rgb.should eql [216, 191, 216] }
      end

      context "of invalid RGB value" do
        it "raise an error" do
          expect { color.new([200, 100, 260]) }.to raise_error ArgumentError
        end
      end
    end
  end

  context "#hex" do
    it { color.new("Alice Blue").hex.should eql "#F0F8FF" }
    it { color.new("Khaki").hex.should eql "#F0E68C" }
    it { color.new("Mint Cream").hex.should eql "#F5FFFA" }
    it { color.new("Thistle").hex.should eql "#D8BFD8" }
  end

  context "#hsb" do
    it { color.new("Alice Blue").hsb.should eql [208, 6, 100] }
    it { color.new("Khaki").hsb.should eql [55, 42, 94] }
    it { color.new("Mint Cream").hsb.should eql [150, 4, 100] }
    it { color.new("Thistle").hsb.should eql [300, 12, 85] }
  end

end


__END__

name2rgb("Alice Blue").should eql [240, 248, 255]
name2rgb("Khaki").should eql [240, 230, 140]
name2rgb("Mint Cream").should eql [245, 255, 250]
name2rgb("Thistle").should eql [216, 191, 216]
