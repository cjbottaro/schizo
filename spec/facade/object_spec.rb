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

      let(:object) do
        base.new
      end

      let(:builder) do
        ObjectBuilder.new(object, role)
      end

      let(:facade) do
        builder.product
      end

      it "is not the same as the original object" do
        facade.should_not == object
      end

      it "responds to methods defined in its role" do
        facade.should respond_to(:bar)
      end

      it "calling methods should not affect original object" do
        facade.bar("test")
        facade.instance_variable_get(:@bar).should == "test"
        object.instance_variable_get(:@bar).should be_nil
      end

      context "#actualize" do

        before(:all) do
          facade.bar("blah")
          facade.actualize
        end

        it "returns the original object" do
          facade.actualize.should == object
        end

        it "sets instance variables in the original object" do
          object.instance_variable_get(:@bar).should == "blah"
        end

        it "does not set any internal dci instance variables" do
          object.instance_variable_defined?(Schizo::Facade::DCI_INSTANCE_VARIABLE).should be_false
        end

      end

    end

  end
end
