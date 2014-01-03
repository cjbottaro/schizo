require "spec_helper"

module Schizo
  module Facade

    describe "a facade object" do

      let(:base) do
        Class.new do
        end
      end

      let(:role) do
        Module.new do
          extend Role
          def bar(v)
            @bar = v
          end
        end
      end

      let(:concern) do
        Module.new do
          extend ActiveSupport::Concern
          def baz(v)
            @baz = v
          end
        end
      end

      let(:object) do
        base.new
      end

      let(:facade_class) do
        ClassBuilder.new(base, role).product
      end

      let(:concern_facade_class) do
        ClassBuilder.new(base, concern).product
      end

      let(:builder) do
        ObjectBuilder.new(object, facade_class, role)
      end

      let(:concern_builder) do
        ObjectBuilder.new(object, concern_facade_class, concern)
      end

      let(:facade) do
        builder.product
      end

      let(:concern_facade) do
        concern_builder.product
      end

      it "is not the same as the original object" do
        facade.should_not == object
        concern_facade.should_not == object
      end

      it "responds to methods defined in its role" do
        facade.should respond_to(:bar)
        # concern_facade.should respond_to(:baz)
      end

      it "calling methods should not affect original object" do
        facade.bar("test")
        facade.instance_variable_get(:@bar).should == "test"
        concern_facade.baz("test")
        concern_facade.instance_variable_get(:@baz).should == "test"
        object.instance_variable_get(:@bar).should be_nil
        object.instance_variable_get(:@baz).should be_nil
      end

      context "#actualize" do

        before(:all) do
          facade.bar("blah")
          facade.actualize

          concern_facade.baz("blah")
          concern_facade.actualize
        end

        it "returns the original object" do
          facade.actualize.should == object
          concern_facade.actualize.should == object
        end

        it "sets instance variables in the original object" do
          object.instance_variable_get(:@bar).should == "blah"
          object.instance_variable_get(:@baz).should == "blah"
        end

        it "does not set any internal dci instance variables" do
          object.instance_variable_defined?(Schizo::Facade::DCI_INSTANCE_VARIABLE).should be_false
        end

      end

    end

  end
end
