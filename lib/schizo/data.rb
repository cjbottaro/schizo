module Schizo

  # Include Data into a class to give it the ability to be adorned with a Role.
  module Data

    # Adorn a Data object with a Role.
    #
    # If a block is given, then a facade for _self_ is yielded to the block and the return value
    # is _self_ with the facade's instance variables copied over to it.
    #   user.name = "callie"
    #   user.as(Poster) do |poster|
    #     poster.name = "coco"
    #   end
    #   user.name # => "coco"
    #
    # Without a block, a facade for _self_ is returned.
    #   user.name = "callie"
    #   poster = user.as(Poster)
    #   poster.name = "coco"
    #   user.name # => "callie"
    def as(role, &block)
      facade = Facade::ObjectBuilder.new(self, role).product
      if block_given?
        block.call(facade)
        facade.actualize
      else
        facade
      end
    end

  end
end
