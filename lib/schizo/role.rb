module Schizo
  # It is a functional copy of ActiveSupport::Concern
  #
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
    #   User.new.as(Poster).do |poster|
    #     poster.posts.create :title => "My first post!"
    #   end
    class MultipleIncludedBlocks < StandardError #:nodoc:
      def initialize
        super "Cannot define multiple 'included' blocks for a Concern"
      end
    end

    def self.extended(base) #:nodoc:
      base.instance_variable_set(:@_dependencies, [])
    end

    def append_features(base)
      if base.instance_variable_defined?(:@_dependencies)
        base.instance_variable_get(:@_dependencies) << self
        return false
      else
        return false if base < self
        @_dependencies.each { |dep| base.send(:include, dep) }
        super
        base.extend const_get(:ClassMethods) if const_defined?(:ClassMethods)
        base.class_eval(&@_included_block) if instance_variable_defined?(:@_included_block)
      end
    end

    def included(base = nil, &block)
      if base.nil?
        raise MultipleIncludedBlocks if instance_variable_defined?(:@_included_block)

        @_included_block = block
      else
        super
      end
    end
  end
end
