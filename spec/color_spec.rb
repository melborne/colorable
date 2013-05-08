require_relative 'spec_helper'

include Colorable
describe Color do
  describe ".new" do
    context "with a string" do
      context "of valid colorname" do
        it { Color.new("Alice Blue").name.to_s.should eql "Alice Blue" }
        it { Color.new("Khaki").name.to_s.should eql "Khaki" }
        it { Color.new("Mint Cream").name.to_s.should eql "Mint Cream" }
        it { Color.new("Thistle").name.to_s.should eql "Thistle" }
      end

      context "of valid name variations" do
        it { Color.new("AliceBlue").name.to_s.should eql "Alice Blue" }
        it { Color.new("aliceblue").name.to_s.should eql "Alice Blue" }
        it { Color.new("aliceblue").name.to_s.should eql "Alice Blue" }
        it { Color.new(:AliceBlue).name.to_s.should eql "Alice Blue" }
        it { Color.new(:aliceblue).name.to_s.should eql "Alice Blue" }
        it { Color.new(:alice_blue).name.to_s.should eql "Alice Blue" }
      end

      context "of invalid name" do
        it "raise an error" do
          expect { Color.new("Alice-Blue") }.to raise_error ArgumentError
          expect { Color.new("Alice") }.to raise_error ArgumentError
        end
      end
    end

    context "with an array" do
      context "of valid RGB value" do
        it { Color.new([240, 248, 255]).rgb.to_a.should eql [240, 248, 255] }
        it { Color.new([240, 230, 140]).rgb.to_a.should eql [240, 230, 140] }
        it { Color.new([245, 255, 250]).rgb.to_a.should eql [245, 255, 250] }
        it { Color.new([216, 191, 216]).rgb.to_a.should eql [216, 191, 216] }
      end

      context "of invalid RGB value" do
        it "raise an error" do
          expect { Color.new([200, 100, 260]) }.to raise_error ArgumentError
        end
      end
    end

    context "with a RGB or HSB object" do
      it { Color.new(RGB.new 240, 248, 255).name.to_s.should eql "Alice Blue"}
      it { Color.new(HSB.new 208, 6, 100).name.to_s.should eql "Alice Blue"}
    end
  end

  describe "#hex" do
    it { Color.new("Alice Blue").hex.should eql "#F0F8FF" }
    it { Color.new("Khaki").hex.should eql "#F0E68C" }
    it { Color.new("Mint Cream").hex.should eql "#F5FFFA" }
    it { Color.new("Thistle").hex.should eql "#D8BFD8" }
  end

  describe "#hsb" do
    it { Color.new("Alice Blue").hsb.to_a.should eql [208, 6, 100] }
    it { Color.new("Khaki").hsb.to_a.should eql [55, 42, 94] }
    it { Color.new("Mint Cream").hsb.to_a.should eql [150, 4, 100] }
    it { Color.new("Thistle").hsb.to_a.should eql [300, 12, 85] }
  end

  describe '#red, #green, #blue, #hue, #sat, #bright' do
    subject { Color.new :alice_blue }
    its(:red) { should eql 240 }
    its(:green) { should eql 248 }
    its(:blue) { should eql 255 }
    its(:hue) { should eql 208 }
    its(:sat) { should eql 6 }
    its(:bright) { should eql 100 }
  end

  describe "#next" do
    context "with :NAME mode" do
      subject { Color.new :khaki }
      it { subject.next.to_s.should eql 'Lavender' }
      it { subject.next(2).to_s.should eql 'Lavender Blush' }
    end

    context "with :RGB mode" do
      subject { Color.new [240, 230, 140] }
      it { subject.next.to_s.should eql "rgb(240,248,255)" }
      it { subject.next(2).to_s.should eql "rgb(240,255,240)" }
    end

    context "with :HSB mode" do
      before do
        @c = Color.new :khaki
        @c.mode = :HSB
      end
      it { @c.next.to_s.should eql "hsb(56,43,74)" } #Dark Khaki
      it { @c.next(2).to_s.should eql "hsb(60,6,100)" } #Ivory
    end

    context "when color is not in X11 colorset" do
      it { Color.new([100,10,10]).name.should be_nil }
    end
  end

  describe "#prev" do
    context "with :NAME mode" do
      subject { Color.new :khaki }
      it { subject.prev.to_s.should eql 'Ivory' }
      it { subject.prev(2).to_s.should eql 'Indigo' }
    end

    context "with :RGB mode" do
      subject { Color.new [240, 230, 140] }
      it { subject.prev.to_s.should eql "rgb(240,128,128)" } #Light Coral
      it { subject.prev(2).to_s.should eql "rgb(238,232,170)" } #Pale Goldenrod
    end

    context "with :HSB mode" do
      before do
        @c = Color.new :khaki
        @c.mode = :HSB 
      end
      it { @c.prev.to_s.should eql "hsb(55,29,93)" } #Pale Goldenrod
      it { @c.prev(2).to_s.should eql "hsb(55,20,100)" } #Lemon Chiffon
    end

    context "when color is not in X11 colorset" do
      it { Color.new([100,10,10]).name.should be_nil }
    end
  end

  describe "#mode=" do
    context "init with colorname" do
      subject { Color.new :black }
      its(:mode) { should eql :NAME }
      it { subject.instance_variable_get(:@mode).to_s.should eql "Black"}
    end

    context "init with rgb values" do
      subject { Color.new([240, 248, 255]) }
      its(:mode) { should eql :RGB }
      it { subject.instance_variable_get(:@mode).to_s.should eql "rgb(240,248,255)"}
    end

    context "init with HSB class" do
      subject { Color.new(HSB.new 208, 6, 100) }
      its(:mode) { should eql :HSB }
      it { subject.instance_variable_get(:@mode).to_s.should eql "hsb(208,6,100)"}
    end
  end

  describe "#to_s" do
    context "default" do
      it { Color.new(:alice_blue).to_s.should eql "Alice Blue" }
    end

    context "with name mode" do
      before do
        @c = Color.new(:alice_blue)
        @c.mode = :name
      end
      it { @c.mode.should eql :NAME }
      it { @c.to_s.should eql "Alice Blue" }
    end

    context "with rgb mode" do
      before do
        @c = Color.new(:alice_blue)
        @c.mode = :rgb
      end
      it { @c.mode.should eql :RGB }
      it { @c.to_s.should eql "rgb(240,248,255)" }
    end

    context "with hsb mode" do
      before do
        @c = Color.new(:alice_blue)
        @c.mode = :hsb
      end
      it { @c.mode.should eql :HSB }
      it { @c.to_s.should eql "hsb(208,6,100)" }
    end
  end

  describe "#+" do
    context "with :NAME mode" do
      before { @c = Color.new :khaki }
      it { (@c + 1).to_s.should eql 'Lavender' }
      it { (@c + 2).to_s.should eql 'Lavender Blush' }
    end

    context "with rgb mode" do
      before do
        @c = Color.new([100, 100, 100])
        @c.mode = :rgb
        @c2 = @c + [0, 50, 100]
      end
      it { @c2.to_s.should eql "rgb(100,150,200)" }
      it { @c.to_s.should eql "rgb(100,100,100)" }
    end

    context "with hsb mode" do
      before do
        @c = Color.new(HSB.new(250, 10, 80))
        @c.mode = :hsb
        @c2 = @c + [100, 10, 5]
      end
      it { @c2.to_s.should eql "hsb(350,20,85)" }
      it { @c.to_s.should eql "hsb(250,10,80)" }
    end
  end

  describe "#-" do
    context "with :NAME mode" do
      before { @c = Color.new :khaki }
      it { (@c - 1).to_s.should eql 'Ivory' }
      it { (@c - 2).to_s.should eql 'Indigo' }
    end

    context "with rgb mode" do
      before do
        @c = Color.new([100, 150, 200])
        @c.mode = :rgb
        @c2 = @c - [0, 50, 100]
      end
      it { @c.to_s.should eql "rgb(100,150,200)" }
      it { @c2.to_s.should eql "rgb(100,100,100)" }
    end

    context "with hsb mode" do
      before do
        @c = Color.new(HSB.new(350, 20, 85))
        @c.mode = :hsb
        @c2 = @c - [100, 10, 5]
      end
      it { @c.to_s.should eql "hsb(350,20,85)" }
      it { @c2.to_s.should eql "hsb(250,10,80)" }
    end
  end

  describe "#dark?" do
    it { Color.new(:black).dark?.should eql true }
    it { Color.new(:yellow).dark?.should eql false }
  end

  describe "#info" do
    it 'returns data of the color' do
      info = { 
        NAME:'Black',
        RGB:[0, 0, 0],
        HSB:[0, 0, 0],
        HEX:'#000000',
        MODE: :NAME,
        DARK:true
      }
      Color.new(:black).info.should eql info
    end
  end
end
