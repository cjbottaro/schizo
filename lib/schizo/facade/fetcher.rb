require "thread"

module Schizo
  module Facade
    class Fetcher

      @lock = Mutex.new
      @facades = {}

      class << self
        attr_reader :lock, :facades
      end

      attr_reader :base_class, :roles

      def initialize(base_class, roles)
        @base_class, @roles = base_class, roles
        verify_roles!
      end

      def call
        lock.synchronize{ fetch or build }
      end

    private

      def fetch
        facades[key]
      end

      def build
        facades[key] = facade_class
      end

      def facade_class
        @facade_class ||= begin
          facade_class = Class.new(base_class){ include(Schizo::Facade) }
          roles.each{ |role| facade_class.send(:include, role) }
          meta_data = Struct.new(:name, :roles).new(base_class.name, roles)
          facade_class.instance_variable_set(:@schizo, meta_data)
          facade_class
        end
      end

      def key
        @key ||= [base_class] + roles
      end

      def verify_roles!
        roles.each do |role|
          if role.kind_of?(Schizo::Role)
            nil
          elsif defined?(ActiveSupport::Concern) and role.kind_of?(ActiveSupport::Concern)
            nil
          else
            raise(Schizo::RoleError, "#{role} is not a role")
          end
        end
      end

      def lock; self.class.lock; end
      def facades; self.class.facades; end

    end
  end
end
