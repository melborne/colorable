require_relative 'spec_helper'

describe Colorable do
	describe "String#to_color" do
		context "apply a colorname string" do
		  subject { "Lime Green".to_color }
		  it { should be_instance_of Colorable::Color }
		  its(:to_s) { should eql "Lime Green" }
		end

		context "apply a hex string" do
		  subject { "#32CD32".to_color }
		  it { should be_instance_of Colorable::Color }
		  its(:to_s) { should eql "#32CD32" }
		end

		context "apply a invalid string" do
			it "raise ArgumentError" do
			 	expect { "Bad Green".to_color }.to raise_error ArgumentError
			end
		end
	end 

	describe "Symbol#to_color" do
		context "apply a colorname symbol" do
		 	subject { :lime_green.to_color } 
		  it { should be_instance_of Colorable::Color }
		  its(:to_s) { should eql "Lime Green" }
		end

		context "apply a invalid symbol" do
			it "raise ArgumentError" do
			 	expect { :bad_green.to_color }.to raise_error ArgumentError
			end
		end
	end

	describe "Array#to_color" do
		context "apply a RGB values" do
		 	subject { [50, 205, 50].to_color } 
		  it { should be_instance_of Colorable::Color }
		  its(:to_s) { should eql "rgb(50,205,50)" }
		end

		context "apply a invalid array" do
			it "raise ArgumentError" do
			 	expect { [50, 205].to_color }.to raise_error ArgumentError
			 	expect { [50, 205, 300].to_color }.to raise_error ArgumentError
			 	expect { ['50', '205', '205'].to_color }.to raise_error ArgumentError
			end
		end
	end
end