module Porch
  class ProcStepDecorator
    attr_reader :step

    def initialize(step, _organizer)
      @step = step
    end

    def execute(context)
      ctx = Context.new(context)
      step.call ctx
      ctx
    end

    def self.decorates?(step)
      step.is_a? Proc
    end
  end
end
