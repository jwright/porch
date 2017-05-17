require_relative "rescuable"

module Porch
  module Organizer
    attr_reader :context

    def with(parameters={})
      @context = Context.new parameters

      chain = StepChain.new(self)
      yield chain if block_given?

      chain.execute context
    end

    def self.included(base)
      base.class_eval do
        include Rescuable
      end
    end
  end
end
