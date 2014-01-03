require "spec_helper"

describe "a nested facade for ClassA with RoleA, RoleB and RoleC" do

  let(:class_a) do
    Class.new do
      include Schizo::Data
      attr_reader :foo, :bar, :baz
    end
  end

  let(:role_a) do
    Module.new do
      extend Schizo::Role
      def set_foo; @foo = "foo"; end
    end
  end

  let(:role_b) do
    Module.new do
      extend Schizo::Role
      def set_bar; @bar = "bar"; end
    end
  end

  let(:role_c) do
    Module.new do
      extend ActiveSupport::Concern
      def set_baz; @baz = "baz"; end
    end
  end

  let(:object) do
    class_a.new
  end

  let(:facade_a) do
    object.as(role_a)
  end

  let(:facade_b) do
    facade_a.as(role_b)
  end

  let(:facade_c) do
    facade_b.as(role_c)
  end

  let(:facade_a_b_c) do
    object.as(role_a, role_b, role_c)
  end

  it "#instance_of?(ClassA) is true" do
    facade_c.should be_instance_of(class_a)
    facade_a_b_c.should be_instance_of(class_a)
  end

  it "#kind_of?(ClassA) is true" do
    facade_c.should be_kind_of(class_a)
    facade_a_b_c.should be_kind_of(class_a)
  end

  it "should have methods from RoleA, RoleB and RoleC" do
    facade_a.should respond_to(:set_foo)
    facade_a.should_not respond_to(:set_bar)
    facade_a.should_not respond_to(:set_baz)

    facade_b.should respond_to(:set_foo)
    facade_b.should respond_to(:set_bar)
    facade_a.should_not respond_to(:set_baz)

    facade_c.should respond_to(:set_foo)
    facade_c.should respond_to(:set_bar)
    facade_c.should respond_to(:set_baz)

    facade_a_b_c.should respond_to(:set_foo)
    facade_a_b_c.should respond_to(:set_bar)
    facade_a_b_c.should respond_to(:set_baz)
  end

  it "#actualize should walk up the chain" do
    facade_c.set_foo
    facade_c.set_bar
    facade_c.set_baz

    facade_c.foo.should == "foo"
    facade_c.bar.should == "bar"
    facade_c.baz.should == "baz"

    facade_b.foo.should be_nil
    facade_b.bar.should be_nil
    facade_b.baz.should be_nil

    facade_a.foo.should be_nil
    facade_a.bar.should be_nil
    facade_a.baz.should be_nil

    facade_c.actualize

    facade_b.foo.should == "foo"
    facade_b.bar.should == "bar"
    facade_b.baz.should == "baz"

    facade_a.foo.should be_nil
    facade_a.bar.should be_nil
    facade_a.baz.should be_nil

    facade_b.actualize

    facade_a.foo.should == "foo"
    facade_a.bar.should == "bar"
    facade_a.baz.should == "baz"
  end

end
