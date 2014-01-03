require "spec_helper"

module Schizo
  module Facade

    describe(ObjectBuilder) do

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
          def bar(v)
            @bar = v
          end
        end
      end

      let(:object) do
        base.new
      end

      let(:facade_class) do
        ClassBuilder.new(object.class, role).product
      end

      let(:builder) do
        ObjectBuilder.new(object, facade_class, role)
      end

      let(:concern_builder) do
        ObjectBuilder.new(object, facade_class, concern)
      end

      context "#initialize" do

        it "sets object and role" do
          builder.object.should == object
          builder.role.should == role

          concern_builder.object.should == object
          concern_builder.role.should == concern
        end

      end

      context "#product" do

        it "returns a facade object" do
          builder.product.should be_a(base)
          builder.product.should be_instance_of(base)

          concern_builder.product.should be_a(base)
          concern_builder.product.should be_instance_of(base)
        end

      end

    end

  end
end
