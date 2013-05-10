require_relative 'spec_helper'

include Colorable
describe Colorset do
  describe ".new" do
    context "default(NAME order)" do
      subject { Colorset.new }
      it { should be_a_instance_of Colorset }
      it { subject.take(3).map(&:to_s).should eql ["Alice Blue", "Antique White", "Aqua"] }
    end

    context "with RGB order" do
      subject { Colorset.new order:'RGB' }
      it { subject.take(3).map(&:to_s).should eql ['rgb(0,0,0)', 'rgb(0,0,128)', 'rgb(0,0,139)'] }
      it { subject.last.to_s.should eql 'rgb(255,255,255)' }
    end

    context "with red order" do
      subject { Colorset.new order: :red }
      it { subject.take(3).map(&:to_s).should eql ['rgb(0,0,0)', 'rgb(0,0,128)', 'rgb(0,0,139)'] }
      it { subject.last.to_s.should eql 'rgb(255,255,255)' }
    end

    context "with green order, reverse direction" do
      subject { Colorset.new order:'green', dir:'-' }
      it { subject.take(3).map(&:to_s).should eql ['rgb(255,255,255)', 'rgb(255,255,240)', 'rgb(255,255,224)'] }
      it { subject.last(3).map(&:to_s).should eql ['rgb(0,0,139)', 'rgb(0,0,128)', 'rgb(0,0,0)'] }
    end

    context "with HSB order" do
      subject { Colorset.new order: :hsb }
      it { subject.take(3).map(&:to_s).should eql ['hsb(0,0,0)', 'hsb(0,0,41)', 'hsb(0,0,50)'] }
      it { subject.last.to_s.should eql 'hsb(352,29,100)' }
    end

    context "with HEX order" do
      subject { Colorset.new order: :hex }
      it { subject.take(3).map(&:to_s).should eql ["#000000", "#000080", "#00008B"] }
      it { subject.last.to_s.should eql '#FFFFFF' }
    end
  end

  describe "#at" do
    context "with NAME order" do
      subject { Colorset.new }
      it { subject.at.to_s.should eql 'Alice Blue' }
      it { subject.at(1).to_s.should eql 'Antique White' }
    end

    context "with RGB order" do
      subject { Colorset.new order: :green }
      it { subject.at.to_s.should eql 'rgb(0,0,0)' }
      it { subject.at(1).to_s.should eql 'rgb(0,0,128)' }
    end

    context "when argument exceed colorset size" do
      it "acts like circularly linked list" do
        Colorset.new.at(144).name.to_s.should eql "Alice Blue"
      end
    end
  end

  describe "#next" do
    before(:all) { @cs = Colorset.new }
    it { @cs.next.name.to_s.should eql 'Antique White' }
    it { @cs.next.name.to_s.should eql 'Aqua' }
    it { @cs.next(2).name.to_s.should eql 'Azure' }
  end

  describe "#prev" do
    before(:all) { @cs = Colorset.new(order: :hsb) }
    it { @cs.prev.name.to_s.should eql 'Light Pink' }
    it { @cs.prev.name.to_s.should eql 'Pink' }
    it { @cs.prev.name.to_s.should eql 'Crimson' }
    it { @cs.prev(2).name.to_s.should eql 'Lavender Blush' }
  end

  describe "#rewind" do
    before(:all) { @cs = Colorset.new }
    it { @cs.next(10); @cs.rewind.name.to_s.should eql 'Alice Blue' }
  end

  describe "#size" do
    it "returns size of colorset" do
      Colorset.new.size.should eql 144
    end
  end

  describe "#to_s" do
    before(:all) { @cs = Colorset.new }
    it { @cs.to_s.should eql "#<Colorset 0/144 pos='Alice Blue/rgb(240,248,255)/hsb(208,6,100)'>"}
    it { @cs.next;@cs.to_s.should eql "#<Colorset 1/144 pos='Antique White/rgb(250,235,215)/hsb(35,14,98)'>"}
  end
end
