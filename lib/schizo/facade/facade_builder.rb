module Schizo
  module Facade #:nodoc:
    class FacadeBuilder #:nodoc:

      attr_reader :object, :role

      def initialize(object, role)
        @object, @role = object, role
      end

      # Returns a facade
      # Ex:
      #   builder = FacadeBuilder.new(user, Poster)
      #   builder.product                           # => Schizo::Facades::User::Poster
      def product
        facade_class = Facade::ClassBuilder.new(object.class, role).product
        facade = Facade::ObjectBuilder.new(object, facade_class, role).product
      end


    end
  end
end
