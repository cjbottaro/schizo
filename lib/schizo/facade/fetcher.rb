require "thread"
require "delegate"

module Schizo
  module Facade
    class Fetcher

      @lock = Mutex.new
      @facades = {}
      @hacked_classes = Set.new

      class << self
        attr_reader :lock, :facades, :hacked_classes
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
          facade_class.instance_variable_set(:@schizo_name, base_class.name)
          roles.each{ |role| facade_class.send(:include, role) }
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
      def hacked_classes; self.class.hacked_classes; end

    end
  end
end
