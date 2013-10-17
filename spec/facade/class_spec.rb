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

      let(:concern) do
        Module.new do
          extend ActiveSupport::Concern
          included do
            @test_concern_var = 1
          end
        end
      end

      let(:concern_builder) do
        ClassBuilder.new(base, concern)
      end

      let(:builder) do
        ClassBuilder.new(base, role)
      end

      let(:facade) do
        builder.product
      end

      let(:concern_facade) do
        concern_builder.product
      end

      it "has the same #name as its superclass" do
        facade.name.should == "Foo"
        concern_facade.name.should == "Foo"
        base.name.should == "Foo"
      end

      it "#initialize has arity == 2" do
        base.instance_method(:initialize).arity.should < 2
        facade.instance_method(:initialize).arity.should == 2
        concern_facade.instance_method(:initialize).arity.should == 2
      end

      it "has class evaled the extended block of the role" do
        facade.should be_instance_variable_defined(:@test_var)
        concern_facade.should be_instance_variable_defined(:@test_concern_var)
      end

      it "is defined in Schizo::Facades" do
        facade.should == Schizo::Facades.const_get(base.name).const_get("AnonRole#{role.object_id}")
        concern_facade.should == Schizo::Facades.const_get(base.name).const_get("AnonRole#{concern.object_id}")
      end

      it "is a singleton" do
        facade.object_id.should == ClassBuilder.new(base, role).product.object_id
        concern_facade.object_id.should == ClassBuilder.new(base, concern).product.object_id
      end

    end

  end
end
