require "spec_helper"

module DelegateClassSpec

  class Foo
    attr_accessor :foo
  end

  class Bar < DelegateClass(Foo)
    attr_accessor :bar
  end

  describe "DelegateClass" do

    let(:foo){ Foo.new }
    let(:bar){ Bar.new(foo) }

    it "#is_a? is not delegated" do
      expect(bar).to be_a(Bar)
      expect(bar).to_not be_a(Foo)
    end

    it "#kind_of? is not delegated" do
      expect(bar).to be_kind_of(Bar)
      expect(bar).to_not be_kind_of(Foo)
    end

    it "#to_s is delegated" do
      expect(bar.to_s).to eq(foo.to_s)
    end

    it "#inspect is delegated" do
      expect(bar.inspect).to eq(foo.inspect)
    end
    
    it "#object_id is not delegated" do
      expect(bar.object_id).to_not eq(foo.object_id)
    end

    it "#=== is not delegated" do
      Foo.should_not === bar
      Bar.should === bar
    end

  end

end
