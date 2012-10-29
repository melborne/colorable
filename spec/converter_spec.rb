require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

include Colorable::Converter
describe Colorable::Converter do
  let(:conv) { Colorable::Converter }
  describe "#name2rgb" do
    context "when name exsist" do
      it "return a RGB value" do
        name2rgb("Alice Blue").should eql [240, 248, 255]
        name2rgb("Khaki").should eql [240, 230, 140]
        name2rgb("Mint Cream").should eql [245, 255, 250]
        name2rgb("Thistle").should eql [216, 191, 216]
      end
    end

    context "when name not exist" do
      it "raise NoNameError" do
        expect { name2rgb("Hello Yellow") }.to raise_error conv::NoNameError
      end
    end
  end

  describe "#rgb2name" do
    context "when name exist" do
      it "returns a name" do
        rgb2name([240, 248, 255]).should eql "Alice Blue"
        rgb2name([216, 191, 216]).should eql "Thistle"
      end
    end

    context "when name not exist" do
      it "returns nil" do
        rgb2name([240, 240, 240]).should be_nil
      end
    end

    context "when invalid rgb" do
      it "raise ArgumentError" do
        expect { rgb2name([0, 260, 0]) }.to raise_error ArgumentError
      end
    end
  end
  
  describe "#rgb2hsb" do
    context "when a valid rgb" do
      it "returns a HSB value" do
        rgb2hsb([240, 248, 255]).should eql [208, 6, 100]
        rgb2hsb([216, 191, 216]).should eql [300, 12, 85]
        rgb2hsb([240, 230, 140]).should eql [55, 42, 94]
      end
    end

    context "when a invalid rgb" do
      it "raise ArgumentError" do
        expect { rgb2hsb([100, 100, -10]) }.to raise_error ArgumentError
      end
    end
  end

  describe "#hsb2rgb" do
    context "when a valid hsb" do
      it "returns a RGB value" do
        hsb2rgb([208, 6, 100]).should eql [240, 248, 255]
        hsb2rgb([300, 12, 85]).should eql [217, 191, 217] # hava a margin of error
        hsb2rgb([55, 42, 94]).should eql [240, 231, 139]  # hava a margin of error
      end
    end

    context "when a invalid hsb" do
      it "raise ArgumentError" do
        expect { hsb2rgb([-100, 50, 50]) }.to raise_error ArgumentError
        expect { hsb2rgb([350, 101, 50]) }.to raise_error ArgumentError
        expect { hsb2rgb([0, 50, -50]) }.to raise_error ArgumentError
      end
    end
  end

  describe "#rgb2hex" do
    context "when a valid rgb" do
      it "returns a HEX value" do
        rgb2hex([240, 248, 255]).should eql '#F0F8FF'
        rgb2hex([216, 191, 216]).should eql '#D8BFD8'
        rgb2hex([240, 230, 140]).should eql '#F0E68C'
      end
    end

    context "when a invalid rgb" do
      it "raise ArgumentError" do
        expect { rgb2hex([100, 100, -10]) }.to raise_error ArgumentError
      end
    end
  end

  describe "#hex2rgb" do
    
  end
end
