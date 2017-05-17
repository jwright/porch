require_relative "rescuable"

module Porch
  module Organizer
    attr_reader :context

    def with(parameters={})
      @context = Context.new parameters

      handle_exceptions do
        chain = StepChain.new(self)
        yield chain if block_given?

        chain.execute context
      end
    end

    def self.included(base)
      base.class_eval do
        include Rescuable
      end
    end
  end
end
