require "spec_helper"

module SchizoSpec

  class Foo
    include Schizo::Data
    def foo; "foo"; end
  end

  module Bar
    extend Schizo::Role

    included do
      def bar1; "bar1"; end
      def self.bar2; "bar2"; end
    end

    module ClassMethods
      def bar3; "bar3"; end
    end

    def bar2; self.class.bar2; end
    def bar3; self.class.bar3; end
    def bar4; "bar4"; end
  end

  describe Schizo do

    context "facades adorned with Schizo::Role" do

      let(:foo){ Foo.new }
      let(:bar){ foo.as(Bar) }

      it "respond to the role methods" do
        expect(bar.bar1).to eq("bar1")
        expect(bar.bar2).to eq("bar2")
        expect(bar.bar3).to eq("bar3")
        expect(bar.bar4).to eq("bar4")
      end

      it "can return a list of roles" do
        expect(bar.schizo.roles).to eq([Bar])
      end

      it "facade is not #instance_of base object or base class" do
        expect(bar).to_not be_instance_of(Bar)
        expect(bar).to_not be_instance_of(Foo)
      end

      it "#is_a? works with the facade's base class" do
        expect(bar).to be_a(Foo)
      end

      it "#is_a? works with the facade's role" do
        expect(bar).to be_a(Bar)
      end

      it "#kind_of? works with the facade's base class" do
        expect(bar).to be_kind_of(Foo)
      end

      it "#kind_of? works with the facade's role" do
        expect(bar).to be_kind_of(Bar)
      end

      it "#=== works with the facade's base class" do
        Foo.should === bar
      end

      it "#=== works with the facade's role" do
        Bar.should === bar
      end

      it "#to_s looks like the base object" do
        expect(bar.to_s).to match(/#<#{Foo}:0x[0-9a-f]+>/)
      end

      it "#inspect looks like base object" do
        expect(bar.inspect).to match(/#<#{Foo}:0x[0-9a-f]+>/)
      end

    end

  end

end
