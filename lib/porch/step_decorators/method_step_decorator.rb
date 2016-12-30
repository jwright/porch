module Porch
  class MethodStepDecorator
    attr_reader :step

    def initialize(step)
      @step = step
    end

    def execute(context)
      Context.new(context)
    end

    def self.decorates?(step)
      step.is_a?(Symbol) || step.is_a?(String)
    end
  end
end
