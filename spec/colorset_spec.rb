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
      it { @cs.take(3).map(&:to_s).should eql ['rgb(0,0,0)', 'rgb(0,0,128)', 'rgb(0,0,139)'] }
      it { @cs.last.to_s.should eql 'rgb(255,255,255)' }
    end

    context "when :red" do
      before(:all) { @cs = colorset[:red] }
      it { @cs.take(3).map(&:to_s).should eql ['rgb(0,0,0)', 'rgb(0,0,128)', 'rgb(0,0,139)'] }
      it { @cs.last.to_s.should eql 'rgb(255,255,255)' }
    end

    context "when :green in descent order" do
      before(:all) { @cs = colorset[:green, :-] }
      it { @cs.take(3).map(&:to_s).should eql ['rgb(255,255,255)', 'rgb(255,255,240)', 'rgb(255,255,224)'] }
      it { @cs.last(3).map(&:to_s).should eql ['rgb(0,0,139)', 'rgb(0,0,128)', 'rgb(0,0,0)'] }
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

    context "when argument exceed colorset size" do
      it "acts like linked list" do
        colorset.new.at(144).name.should eql "Alice Blue"
      end
    end
  end

  describe "#next" do
    before(:all) { @cs = colorset.new }
    it { @cs.next.name.should eql 'Antique White' }
    it { @cs.next.name.should eql 'Aqua' }
    it { @cs.next(2).name.should eql 'Azure' }
  end

  describe "#prev" do
    before(:all) { @cs = colorset[:hsb] }
    it { @cs.prev.name.should eql 'Light Pink' }
    it { @cs.prev.name.should eql 'Pink' }
    it { @cs.prev.name.should eql 'Crimson' }
    it { @cs.prev(2).name.should eql 'Lavender Blush' }
  end

  describe "#rewind" do
    before(:all) { @cs = colorset.new }
    it { @cs.next(10); @cs.rewind.name.should eql 'Alice Blue' }
  end

  describe "#size" do
    it "returns size of colorset" do
      colorset.new.size.should eql 144
    end
  end

  describe "#to_s" do
    before(:all) { @cs = colorset.new }
    it { @cs.to_s.should eql "#<Colorset 0/144 pos='Alice Blue:rgb(240,248,255)'>"}
    it { @cs.next;@cs.to_s.should eql "#<Colorset 1/144 pos='Antique White:rgb(250,235,215)'>"}
  end
end
