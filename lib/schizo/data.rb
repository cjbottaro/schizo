module Schizo

  # Include Data into a class to give it the ability to be adorned with a Role.
  module Data

    # Adorn a Data object with a Role.
    #
    #   poster = user.as(Poster)
    #   poster.make_post("Hello world")
    def as(*roles)
      Facade::Class.fetch(self.class, roles).new(self)
    end

  end
end
