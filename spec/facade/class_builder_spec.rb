require "spec_helper"
require "schizo/facade"

module Schizo
  module Facade

    describe ClassBuilder do

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

      let(:builder) do
        ClassBuilder.new(base, role)
      end

      let(:builder_concern) do
        ClassBuilder.new(base, concern)
      end

      it "works with namespaced roles" do
        role.module_eval do
          def self.name
            "Namespaced::Role"
          end
        end

        concern.module_eval do
          def self.name
            "Namespaced::Concern"
          end
        end

        builder.product.to_s.should == "Schizo::Facades::Foo::Namespaced::Role"
        builder_concern.product.to_s.should == "Schizo::Facades::Foo::Namespaced::Concern"
      end

      context "#initialize" do

        it "sets base and role" do
          builder.base.should == base
          builder.role.should == role
          
          builder_concern.base.should == base
          builder_concern.role.should == concern
        end

      end

      context "#product" do

        it "returns a facade class" do
          builder.product.tap do |facade|
            facade.should be_a(Class)
            facade.ancestors.should include(base)
            facade.ancestors.should include(Base)
          end

          builder_concern.product.tap do |facade|
            facade.should be_a(Class)
            facade.ancestors.should include(base)
            facade.ancestors.should include(Base)
          end
        end

      end

    end

  end
end
