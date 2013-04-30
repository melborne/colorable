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

  	context "when '+' makes out of RGB range" do
  		it "raise RGBRangeError" do
	  		expect { rgb.new(100, 100, 100) + [0, 50, 200] }.to raise_error Colorable::RGBRangeError
	  		expect { rgb.new(100, 100, 100) + [0, -150, 0] }.to raise_error Colorable::RGBRangeError
  		end
  	end
  end
end
