require "dry-validation"

module Porch
  module GuardRail
    class Guard
      attr_reader :guarded_object

      def initialize(guarded_object)
        @guarded_object = guarded_object
      end

      def against(&block)
        schema = Dry::Validation.Schema &block
        schema.call guarded_object
      end
    end
  end
end
