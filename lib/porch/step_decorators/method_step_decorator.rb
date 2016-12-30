module Porch
  class MethodStepDecorator
    attr_reader :organizer, :step

    def initialize(step, organizer)
      @step = step
      @organizer = organizer
    end

    def execute(context)
      ctx = Context.new(context)
      organizer.send step, ctx
      ctx
    end

    def self.decorates?(step)
      step.is_a?(Symbol) || step.is_a?(String)
    end
  end
end
