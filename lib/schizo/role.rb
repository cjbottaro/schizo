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
    #   extended{ ... }
    #
    # Call this method with a block and that block will be evaled by the Data object's class when
    # the Data object is adorned with this role.
    #   module Poster
    #     extend Schizo::Role
    #
    #     extended do
    #       has_many :posts
    #     end
    #   end
    #
    #   User.new.as(Poster).do |poster|
    #     poster.posts.create :title => "My first post!"
    #   end
    def extended(object = nil, &block)
      if block_given?
        @extended_block = block
      else
        super
      end
    end

    def extended_block #:nodoc:
      @extended_block
    end

  end
end
