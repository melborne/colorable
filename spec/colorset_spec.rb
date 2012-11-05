require_relative 'spec_helper'

describe Colorable::Colorset do
  let(:colorset) { Colorable::Colorset }
  let(:color) { Colorable::Color }
  describe ".new" do
    it "returns a colorset object" do
      colorset.new.should be_a_instance_of colorset
    end
  end

  describe ".[](order)" do
    context "when :rgb passed" do
      before(:all) { @cs = colorset[:rgb] }
      it { @cs.take(3).to_s.should eql '[rgb(0,0,0), rgb(0,0,128), rgb(0,0,139)]' }
      it { @cs.last.to_s.should eql '[rgb(255,255,255)]' }
    end

    context "when :red" do
      before(:all) { @cs = colorset[:red] }
      it { @cs.take(3).to_s.should eql '[rgb(0,0,0), rgb(0,0,128), rgb(0,0,139)]' }
      it { @cs.last.to_s.should eql '[rgb(255,255,255)]' }
    end

    context "when :green in descent order" do
      before(:all) { @cs = colorset[:green, :-] }
      it { @cs.take(3).to_s.should eql '[rgb(255,255,255), rgb(255,255,240), rgb(255,255,224)]' }
      it { @cs.last(3).to_s.should eql '[rgb(0,0,139), rgb(0,0,128), rgb(0,0,0)]' }
    end
  end

  describe "#at" do
    context "when colorset is ordered RGB" do
      before(:all) { @cs = colorset.new }
      it { @cs.at.to_s.should eql 'rgb(240,248,255)' }
      it { @cs.at(1).to_s.should eql 'rgb(250,235,215)' }
    end

    context "when colorset is ordered RGB" do
      before(:all) { @cs = colorset[:green] }
      it { @cs.at.to_s.should eql 'rgb(0,0,0)' }
      it { @cs.at(1).to_s.should eql 'rgb(0,0,128)' }
    end
  end

  describe "#next" do
    before(:all) { @cs = colorset.new }
    it { @cs.next.should eql @cs.at(1) }
    it { @cs.next.should eql @cs.at(2) }
    it { @cs.next.should eql @cs.at(3) }
    it { @cs.next(2).should eql @cs.at(5) }
  end

  describe "#prev" do
    before(:all) { @cs = colorset[:hsb] }
    it { @cs.prev.should eql @cs.at(-1) }
    it { @cs.prev.should eql @cs.at(-2) }
    it { @cs.prev.should eql @cs.at(-3) }
    it { @cs.prev(2).should eql @cs.at(-5) }
  end

  describe "#rewind" do
    before(:all) { @cs = colorset.new }
    it { @cs.next(10); @cs.rewind.should eql @cs.at }
  end
end
