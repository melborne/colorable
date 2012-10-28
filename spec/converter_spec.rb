require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

include Colorable::Converter
describe Colorable::Converter do
  let(:conv) { Colorable::Converter }
  describe "#name2rgb" do
    context "when name exsist" do
      it "return a rgb" do
       name2rgb("Alice Blue").should eql [240, 248, 255]
      end
      it "return a rgb" do
        name2rgb("Khaki").should eql [240, 230, 140]
      end
      it "return a rgb" do
        name2rgb("Mint Cream").should eql [245, 255, 250]
      end
      it "return a rgb" do
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
      end
      it "returns a name" do
        rgb2name([216, 191, 216]).should eql "Thistle"
      end
    end

    context "when name not exist" do
      it "returns nil" do
        rgb2name([240, 240, 240]).should be_nil
      end
    end

    context "when irregal rgb" do
      it "raise ArgumentError" do
        expect { rgb2name([0, 260, 0]) }.to raise_error ArgumentError
      end
    end
  end
  
  describe "#rgb2hsb" do
    
  end

  describe "#hsb2rgb" do
    
  end

  describe "#rgb2hex" do
    
  end

  describe "#hex2rgb" do
    
  end
end
