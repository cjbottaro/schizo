module Schizo

  # Extend a module with Role to make that module a _role_.
  #   module RoleA
  #     extend Schizo::Role
  #
  #     def method_a
  #     end
  #
  #     def method_b
  #     end
  #   end
  module Role

    # call-seq:
    #   included{ ... }
    #
    # Call this method with a block and that block will be evaled by the Data object's class when
    # the Data object is adorned with this role.
    #   module Poster
    #     extend Schizo::Role
    #
    #     included do
    #       has_many :posts
    #     end
    #   end
    #
    #   poster = User.new.as(Poster)
    #   poster.posts.create :title => "My first post!"
    def included(base = nil, &block)
      if base
        super
      else
        @included_block = block
      end
    end

    def append_features(base)
      # Instance methods
      super

      # Class methods
      base.extend(const_get(:ClassMethods)) if const_defined?(:ClassMethods)

      # Included block
      base.class_eval(&@included_block) if @included_block
    end

  end
end
