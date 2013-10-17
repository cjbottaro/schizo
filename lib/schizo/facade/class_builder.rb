module Schizo
  module Facade #:nodoc:
    class ClassBuilder #:nodoc:

      attr_reader :base, :role

      def initialize(base, role)
        @base, @role = base, role
      end

      # Returns a new class derived off of +base+ and namespaced under role.
      # Ex:
      #   builder = ClassBuilder.new(User, Poster)
      #   builder.product                           # => Schizo::Facades::User::Poster
      #   builder.product.kind_of?(User)            # => true
      def product
        @product ||= begin
          if container_module.const_defined?(class_name, false)
            container_module.const_get(class_name)
          else
            klass = Class.new(base){ include Base }
            if defined?(ActiveSupport::Concern) and role.is_a?(ActiveSupport::Concern)
              klass.send :include, role
            elsif role.is_a?(Schizo::Role)
              klass.class_eval(&role.extended_block) if role.extended_block
            end
            container_module.const_set(class_name, klass)
          end
        end
      end

    private

      def base_name
        base.name || "AnonClass#{base.object_id}"
      end

      def role_name
        role.name || "AnonRole#{role.object_id}"
      end

      def full_name
        @full_name ||= "Schizo::Facades::#{base_name}::#{role_name}"
      end

      def parsed_full_name
        @parsed_full_name ||= full_name.split("::")
      end

      def module_names
        @container_module_name ||= parsed_full_name[0..-2]
      end

      def class_name
        @class_name ||= parsed_full_name[-1]
      end

      def container_module
        @container_module ||= begin
          names = module_names
          mod = get_or_create_module(Object, names.shift)
          while not names.empty?
            mod = get_or_create_module(mod, names.shift)
          end
          mod
        end
      end

      def get_or_create_module(mod, name)
        if mod.const_defined?(name, false)
          mod.const_get(name)
        else
          mod.const_set(name, Module.new)
        end
      end

    end
  end
end
