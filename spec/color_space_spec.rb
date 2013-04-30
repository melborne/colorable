require_relative 'spec_helper'

describe Colorable::RGB do
	let(:rgb) { Colorable::RGB }
  describe ".new" do
  	context "without arguments" do
  		subject	{ rgb.new }
  		its(:to_a) { should eql [0, 0, 0] }
  		its(:rgb) { should eql [0, 0, 0] }
  		its(:red) { should eql 0 }
  		its(:green) { should eql 0 }
  		its(:blue) { should eql 0 }
  	end

  	context "with arguments" do
  		subject { rgb.new 100, 255, 255 }
  		its(:to_a) { should eql [100, 255, 255] }
  		its(:rgb) { should eql [100, 255, 255] }
  		its(:red) { should eql 100 }
  		its(:green) { should eql 255 }
  		its(:blue) { should eql 255 }
  	end

  	context "pass out of RGB range" do
  		it "raise RGBRangeError" do
  			expect { rgb.new(0, 0, 256) }.to raise_error Colorable::RGBRangeError
  			expect { rgb.new(-10, 0, 255) }.to raise_error Colorable::RGBRangeError
  			expect { rgb.new(256, 256, 256) }.to raise_error Colorable::RGBRangeError
  		end
  	end
  end

  describe "#+" do
  	context "pass an array of numbers" do
  		before(:all) { @rgb = rgb.new(100, 100, 100) }
  	  subject { @rgb + [0, 50, 100] }
  	  its(:rgb) { should eql [100, 150, 200] }
  	  it "keep original same" do @rgb.rgb.should eql [100, 100, 100] end
  	end

  	context "when '+' makes out of RGB range or rack of numbers" do
  		it "raise RGBRangeError" do
	  		expect { rgb.new(100, 100, 100) + [0, 50, 200] }.to raise_error Colorable::RGBRangeError
	  		expect { rgb.new(100, 100, 100) + [0, -150, 0] }.to raise_error Colorable::RGBRangeError
	  		expect { rgb.new(100, 100, 100) + [0, 150] }.to raise_error ArgumentError
  		end
  	end

  	context "pass a Fixnum" do
  		before(:all) { @rgb = rgb.new(100, 100, 100) }
  		it { (@rgb + 50).rgb.should eql [150, 150, 150] }
  		it "raise RGBRangeError" do
  		  expect { @rgb + 160 }.to raise_error Colorable::RGBRangeError
  		end
  	end
  end

  describe "#-" do
  	context "pass an array of numbers" do
  		before(:all) { @rgb = rgb.new(100, 100, 100) }
  	  subject { @rgb - [0, 50, 100] }
  	  its(:rgb) { should eql [100, 50, 0] }
  	  it "keep original same" do @rgb.rgb.should eql [100, 100, 100] end
  	end

  	context "when '-' makes out of RGB range" do
  		it "raise RGBRangeError" do
	  		expect { rgb.new(100, 100, 100) - [0, 50, 200] }.to raise_error Colorable::RGBRangeError
	  		expect { rgb.new(100, 100, 100) - [0, -250, 0] }.to raise_error Colorable::RGBRangeError
  		end
  	end

  	context "pass a Fixnum" do
  		before(:all) { @rgb = rgb.new(100, 100, 100) }
  		it { (@rgb - 50).rgb.should eql [50, 50, 50] }
  		it "raise RGBRangeError" do
  		  expect { @rgb - 160 }.to raise_error Colorable::RGBRangeError
  		end
  	end
  end

  describe "#to_s" do
    it { rgb.new(0, 50, 100).to_s.should eql "rgb(0,50,100)"}
  end
end

describe Colorable::HSB do
	let(:hsb) { Colorable::HSB }
  describe ".new" do
  	context "without arguments" do
  		subject	{ hsb.new }
  		its(:to_a) { should eql [0, 0, 0] }
  		its(:hsb) { should eql [0, 0, 0] }
  		its(:hue) { should eql 0 }
  		its(:sat) { should eql 0 }
  		its(:bright) { should eql 0 }
  	end

  	context "with arguments" do
  		subject { hsb.new 300, 70, 90 }
  		its(:to_a) { should eql [300, 70, 90] }
  		its(:hsb) { should eql [300, 70, 90] }
  		its(:hue) { should eql 300 }
  		its(:sat) { should eql 70 }
  		its(:bright) { should eql 90 }
  	end

  	context "pass out of HSB range" do
  		it "raise HSBRangeError" do
  			expect { hsb.new(0, 0, 120) }.to raise_error Colorable::HSBRangeError
  			expect { hsb.new(360, 0, 80) }.to raise_error Colorable::HSBRangeError
  			expect { hsb.new(0, -10, 0) }.to raise_error Colorable::HSBRangeError
  		end
  	end
  end

  describe "#+" do
  	context "pass an array of numbers" do
  		before(:all) { @hsb = hsb.new(300, 70, 90) }
  	  subject { @hsb + [0, 5, 10] }
  	  its(:hsb) { should eql [300, 75, 100] }
  	  it "keep original same" do @hsb.hsb.should eql [300, 70, 90] end
  	end

  	context "when '+' makes out of HSB range or rack of numbers" do
  		it "raise HSBRangeError" do
	  		expect { hsb.new(300, 70, 90) + [0, 50, 0] }.to raise_error Colorable::HSBRangeError
	  		expect { hsb.new(300, 70, 90) + [0, 0, -100] }.to raise_error Colorable::HSBRangeError
	  		expect { hsb.new(300, 70, 90) + [0, 5] }.to raise_error ArgumentError
  		end
  	end
  end
end