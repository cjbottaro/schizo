require "thread"
require "delegate"

require "schizo/errors"

module Schizo
  module Facade
    module Class

      @lock = Mutex.new
      @facades = {}

      def self.fetch(base_class, roles)
        key = [base_class] + roles
        @lock.synchronize do
          if @facades.has_key?(key)
            @facades[key]
          else
            facade_class = DelegateClass(base_class)
            facade_class.send(:include, self)
            roles.each do |role|
              if defined?(ActiveSupport::Concern) and role.kind_of?(ActiveSupport::Concern)
                facade_class.send(:include, role)
              elsif role.kind_of?(Schizo::Role)
                facade_class.send(:include, role)
              else
                raise(Schizo::RoleError, "#{role} is not a role")
              end
            end
            @facades[key] = facade_class
            facade_class
          end
        end

      end

      def is_a?(klass)
        __getobj__.is_a?(klass) or super(klass)
      end

      def kind_of?(klass)
        __getobj__.kind_of?(klass) or super(klass)
      end

      #def inspect
        #"#<#{__getobj__.class}:0x#{__id__.to_s(16)}>"
      #end

    end
  end
end
