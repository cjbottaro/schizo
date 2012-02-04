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

      let(:builder) do
        ClassBuilder.new(base, role)
      end

      context "#initialize" do

        it "sets base and role" do
          builder.base.should == base
          builder.role.should == role
        end

      end

      context "#product" do

        it "returns a facade class" do
          builder.product.tap do |facade|
            facade.should be_a(Class)
            facade.ancestors.should include(base)
            facade.ancestors.should include(Base)
          end
        end

      end

    end

  end
end
