require_relative 'spec_helper'

include Colorable
describe RGB do
  describe ".new" do
  	context "without arguments" do
  		subject	{ RGB.new }
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
  		it "raise RangeError" do
  			expect { RGB.new(0, 0, 256) }.to raise_error ColorSpace::RangeError
  			expect { RGB.new(-10, 0, 255) }.to raise_error ColorSpace::RangeError
  			expect { RGB.new(256, 256, 256) }.to raise_error ColorSpace::RangeError
  		end
  	end
  end

  describe "#+" do
  	context "pass an array of numbers" do
  		before(:all) { @rgb = RGB.new(100, 100, 100) }
  	  subject { @rgb + [0, 50, 100] }
  	  its(:rgb) { should eql [100, 150, 200] }
  	  it "keep original same" do @rgb.rgb.should eql [100, 100, 100] end
  	end

  	context "when '+' makes out of RGB range or rack of numbers" do
  		it "raise RangeError" do
	  		expect { RGB.new(100, 100, 100) + [0, 50, 200] }.to raise_error ColorSpace::RangeError
	  		expect { RGB.new(100, 100, 100) + [0, -150, 0] }.to raise_error ColorSpace::RangeError
      end

      it "raise ArgumentError" do
	  		expect { RGB.new(100, 100, 100) + [0, 150] }.to raise_error ArgumentError
  		end
  	end

  	context "pass a Fixnum" do
  		before(:all) { @rgb = RGB.new(100, 100, 100) }
  		it { (@rgb + 50).rgb.should eql [150, 150, 150] }
  		it "raise RangeError" do
  		  expect { @rgb + 160 }.to raise_error ColorSpace::RangeError
  		end
  	end

    context "coerce make Fixnum#+ accept rgb object" do
      it { (10 + RGB.new(100, 100, 100)).rgb.should eql [110, 110, 110] }
    end
  end

  describe "#-" do
  	context "pass an array of numbers" do
  		before(:all) { @rgb = RGB.new(100, 100, 100) }
  	  subject { @rgb - [0, 50, 100] }
  	  its(:rgb) { should eql [100, 50, 0] }
  	  it "keep original same" do @rgb.rgb.should eql [100, 100, 100] end
  	end

  	context "when '-' makes out of RGB range" do
  		it "raise RangeError" do
	  		expect { RGB.new(100, 100, 100) - [0, 50, 200] }.to raise_error ColorSpace::RangeError
	  		expect { RGB.new(100, 100, 100) - [0, -250, 0] }.to raise_error ColorSpace::RangeError
  		end
  	end

  	context "pass a Fixnum" do
  		before(:all) { @rgb = RGB.new(100, 100, 100) }
  		it { (@rgb - 50).rgb.should eql [50, 50, 50] }
  		it "raise RangeError" do
  		  expect { @rgb - 160 }.to raise_error ColorSpace::RangeError
  		end
  	end
  end

  describe "#to_s" do
    it { RGB.new(0, 50, 100).to_s.should eql "rgb(0,50,100)"}
  end
end

describe HSB do
  describe ".new" do
  	context "without arguments" do
  		subject	{ HSB.new }
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
  		it "raise RangeError" do
  			expect { HSB.new(0, 0, 120) }.to raise_error ColorSpace::RangeError
  			expect { HSB.new(360, 0, 80) }.to raise_error ColorSpace::RangeError
  		end

      it "raise ArgumentError" do
        expect { HSB.new(0, -10, 0) }.to raise_error ColorSpace::RangeError
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
  		it "raise RangeError" do
	  		expect { HSB.new(300, 70, 90) + [0, 50, 0] }.to raise_error ColorSpace::RangeError
	  		expect { HSB.new(300, 70, 90) + [0, 0, -100] }.to raise_error ColorSpace::RangeError
      end

      it "raise ArgumentError" do
	  		expect { HSB.new(300, 70, 90) + [0, 5] }.to raise_error ArgumentError
        expect { HSB.new(300, 70, 90) + 5 }.to raise_error ArgumentError
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
      it "raise RangeError" do
        expect { HSB.new(300, 7, 90) - [305, 0, 10] }.to raise_error ColorSpace::RangeError
        expect { HSB.new(300, 70, 90) - [0, -35, 0] }.to raise_error ColorSpace::RangeError
      end
    end
  end

  describe "#to_s" do
    it { HSB.new(0, 50, 100).to_s.should eql "hsb(0,50,100)"}
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
      subject { NAME.new :abc_color }
      its(:to_s) { should be_nil }
      its(:name) { should be_nil }
      its(:sym) { should be_nil }
    end
  end

  describe "dark?" do
    it { NAME.new(:navy).dark?.should be_true }
    it { NAME.new(:alice_blue).dark?.should be_false }
  end
end