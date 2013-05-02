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
        it { color.new([240, 248, 255]).rgb.to_a.should eql [240, 248, 255] }
        it { color.new([240, 230, 140]).rgb.to_a.should eql [240, 230, 140] }
        it { color.new([245, 255, 250]).rgb.to_a.should eql [245, 255, 250] }
        it { color.new([216, 191, 216]).rgb.to_a.should eql [216, 191, 216] }
      end

      context "of invalid RGB value" do
        it "raise an error" do
          expect { color.new([200, 100, 260]) }.to raise_error ArgumentError
        end
      end
    end

    context "with a RGB or HSB object" do
      it { color.new(Colorable::RGB.new 240, 248, 255).name.should eql "Alice Blue"}
      it { color.new(Colorable::HSB.new 208, 6, 100).name.should eql "Alice Blue"}
    end
  end

  describe "#hex" do
    it { color.new("Alice Blue").hex.should eql "#F0F8FF" }
    it { color.new("Khaki").hex.should eql "#F0E68C" }
    it { color.new("Mint Cream").hex.should eql "#F5FFFA" }
    it { color.new("Thistle").hex.should eql "#D8BFD8" }
  end

  describe "#hsb" do
    it { color.new("Alice Blue").hsb.to_a.should eql [208, 6, 100] }
    it { color.new("Khaki").hsb.to_a.should eql [55, 42, 94] }
    it { color.new("Mint Cream").hsb.to_a.should eql [150, 4, 100] }
    it { color.new("Thistle").hsb.to_a.should eql [300, 12, 85] }
  end

  describe '#red, #green, #blue, #hue, #sat, #bright' do
    subject { color.new :alice_blue }
    its(:red) { should eql 240 }
    its(:green) { should eql 248 }
    its(:blue) { should eql 255 }
    its(:hue) { should eql 208 }
    its(:sat) { should eql 6 }
    its(:bright) { should eql 100 }
  end

  describe "#next" do
    context "when no argument" do
      it "returns next color in name order" do
        @c = color.new("khaki")
        @c.next.name.should eql "Lavender"
      end
    end

    context "when :hsb passed" do
      it "returns next color in hsb order" do
        @c = color.new("khaki")
        @c.next(:hsb).name.should eql "Dark Khaki"
      end
    end

    context "when color is not in X11 colorset" do
      it "returns nil" do
        @c = color.new([100,10,10])
        @c.next.should be_nil
      end
    end
  end

  describe "#prev" do
    context "when no argument" do
      it "returns prev color in name order" do
        @c = color.new("Alice Blue")
        @c.prev.name.should eql "Yellow Green"
      end
    end

    context "when :hsb passed" do
      it "returns prev color in hsb order" do
        @c = color.new("Yellow")
        @c.prev(:hsb).name.should eql "Olive"
      end
    end
  end

  describe "#mode=" do
    context "default" do
      subject { color.new :black }
      its(:mode) { should eql :RGB }
      it { subject.instance_variable_get(:@mode).to_s.should eql "rgb(0,0,0)"}
    end

    context "set to :HSB" do
      before do
        @c = color.new(:black)
        @c.mode = :HSB
      end
      it { @c.mode.should eql :HSB }
      it { @c.instance_variable_get(:@mode).to_s.should eql "hsb(0,0,0)"}
    end
  end

  describe "#to_s" do
    it { color.new(:alice_blue).to_s.should eql "rgb(240,248,255)" }

    context "with rgb mode" do
      before do
        @c = color.new(:alice_blue)
        @c.mode = :rgb
      end
      it { @c.mode.should eql :RGB }
      it { @c.to_s.should eql "rgb(240,248,255)" }
    end

    context "with hsb mode" do
      before do
        @c = color.new(:alice_blue)
        @c.mode = :hsb
      end
      it { @c.mode.should eql :HSB }
      it { @c.to_s.should eql "hsb(208,6,100)" }
    end
  end

  describe "#+" do
    context "with rgb mode" do
      before do
        @c = color.new([100, 100, 100])
        @c.mode = :rgb
        @c2 = @c + [0, 50, 100]
      end
      it { @c2.to_s.should eql "rgb(100,150,200)" }
      it { @c.to_s.should eql "rgb(100,100,100)" }
    end

    context "with hsb mode" do
      before do
        @c = color.new(Colorable::HSB.new(250, 10, 80))
        @c.mode = :hsb
        @c2 = @c + [100, 10, 5]
      end
      it { @c2.to_s.should eql "hsb(350,20,85)" }
      it { @c.to_s.should eql "hsb(250,10,80)" }
    end
  end

  describe "#-" do
    context "with rgb mode" do
      before do
        @c = color.new([100, 150, 200])
        @c.mode = :rgb
        @c2 = @c - [0, 50, 100]
      end
      it { @c.to_s.should eql "rgb(100,150,200)" }
      it { @c2.to_s.should eql "rgb(100,100,100)" }
    end

    context "with hsb mode" do
      before do
        @c = color.new(Colorable::HSB.new(350, 20, 85))
        @c.mode = :hsb
        @c2 = @c - [100, 10, 5]
      end
      it { @c.to_s.should eql "hsb(350,20,85)" }
      it { @c2.to_s.should eql "hsb(250,10,80)" }
    end
  end
end
