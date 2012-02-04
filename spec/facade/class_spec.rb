require "spec_helper"

module Schizo
  module Facade

    describe "a facade class" do

      let(:base) do
        Class.new do
          def self.name; "Foo"; end
        end
      end

      let(:role) do
        Module.new do
          extend Role
          extended do
            @test_var = 1
          end
        end
      end

      let(:builder) do
        ClassBuilder.new(base, role)
      end

      let(:facade) do
        builder.product
      end

      it "has the same #name as its superclass" do
        facade.name.should == "Foo"
        base.name.should == "Foo"
      end

      it "#initialize has arity == 2" do
        base.instance_method(:initialize).arity.should == 0
        facade.instance_method(:initialize).arity.should == 2
      end

      it "has class evaled the extended block of the role" do
        facade.should be_instance_variable_defined(:@test_var)
      end

      it "is defined in Schizo::Facades" do
        facade.should == Schizo::Facades.const_get(base.name).const_get("AnonRole#{role.object_id}")
      end

      it "is a singleton" do
        facade.object_id.should == ClassBuilder.new(base, role).product.object_id
      end

    end

  end
end
