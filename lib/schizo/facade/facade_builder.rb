module Schizo
  module Facade #:nodoc:
    class FacadeBuilder #:nodoc:

      def self.build_facade(object, *roles)
        first_role = roles.first
        rest_roles = *roles[1..-1]

        if rest_roles.empty? # end of recursive call
          facade_class = Facade::ClassBuilder.new(object.class, first_role).product
          facade = Facade::ObjectBuilder.new(object, facade_class, first_role).product
        else # in recursive call
          first_facade = build_facade(object, first_role)
          build_facade(first_facade, *rest_roles)
        end
        
      end

    end
  end
end
