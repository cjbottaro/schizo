module Schizo
  module Facade #:nodoc:
    class ClassBuilder #:nodoc:

      attr_reader :base, :role

      def initialize(base, role)
        @base, @role = base, role
      end

      def product
        @product ||= role_class
      end

    private

      def module_name
        base.name || "AnonClass#{base.object_id}"
      end

      def role_name
        role.name || "AnonRole#{role.object_id}"
      end

      def container_module
        @container_module ||= begin
          if Schizo::Facades.const_defined?(module_name, false)
            Schizo::Facades.const_get(module_name)
          else
            Schizo::Facades.const_set(module_name, Module.new)
          end
        end
      end

      def role_class
        @role_class ||= begin
          if container_module.const_defined?(role_name, false)
            container_module.const_get(role_name)
          else
            container_module.const_set(role_name, build)
          end
        end
      end
      
      def build
        Class.new(base){ include Base }.tap do |klass|
          klass.class_eval(&role.extended_block) if role.extended_block
        end
      end

    end
  end
end
