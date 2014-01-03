module Schizo
  # Rdoc won't let me :nodoc: this module.  Nothing to see here.
  module Facade

    # This module is included in each Data object facade's class.
    module Base

      def self.included(mod) #:nodoc:
        mod.extend(ClassMethods)
        mod.class_eval <<-STR
          attr_reader :#{DCI_INSTANCE_VARIABLE.to_s[1..-1]}
        STR
      end

      module ClassMethods #:nodoc:

        def name
          superclass.name || "AnonClass#{object_id}"
        end

      end

      def initialize(object, role) #:nodoc:
        instance_variable_set(DCI_INSTANCE_VARIABLE, Struct.new(:object, :role).new(object, role))
      end

      def instance_of?(klass) #:nodoc:
        # This is to get it working with nested facades.  We need to traverse
        # superclasses until we get to the first real (non facade) superclass.
        my_superclass = self.class.superclass
        while my_superclass.ancestors.include?(Base) and my_superclass
          my_superclass = my_superclass.superclass
        end
        my_superclass == klass
      end

      # Copy a facade's instance variables to the object it's facading for.
      def actualize
        dci.object.tap{ |object| Schizo::Facade.copy_instance_variables(self, object) }
      end

    end
  end
end
