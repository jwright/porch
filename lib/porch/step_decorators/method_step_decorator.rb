module Porch
  class MethodStepDecorator
    attr_reader :step

    def initialize(step, organizer)
      @step = step
    end

    def execute(context)
      ctx = Context.new(context)
      ctx
    end

    def self.decorates?(step)
      step.is_a?(Symbol) || step.is_a?(String)
    end
  end
end
