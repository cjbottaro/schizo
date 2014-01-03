module Schizo
  module Facade #:nodoc:

    DCI_INSTANCE_VARIABLE = :@dci

    def self.copy_instance_variables(from, to)
      from.instance_variables.each do |ivar_name|
        ivar = from.instance_variable_get(ivar_name)
        to.instance_variable_set(ivar_name, ivar) unless ivar_name == DCI_INSTANCE_VARIABLE
      end
    end

    class ObjectBuilder #:nodoc:
      attr_reader :object, :facade_class, :role

      def initialize(object, facade_class, role)
        @object, @facade_class, @role = object, facade_class, role
      end

      def product
        @product ||= build
      end

    private

      def build
        facade_class.new(object, role).tap do |facade|

          # This is to get nesting to work.  Because each facade keeps a reference to the object
          # it's facading for, we can traverse nested facades.  Each time we find one, we extend
          # its role into facade we're building.
          previous_facade = object
          while previous_facade.respond_to?(:dci)
            if previous_facade.dci.role.is_a?(Schizo::Role)
              facade.extend(previous_facade.dci.role)
            end
            previous_facade = previous_facade.dci.object
          end
          
          if role.is_a?(Schizo::Role)
            facade.extend(role)
          end
          Schizo::Facade.copy_instance_variables(object, facade)
        end
      end

    end
  end
end
