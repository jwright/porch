module Porch
  class StepChain
    attr_reader :steps

    def initialize
      @steps = []
    end

    def add(step)
      steps << ExecutableStepDecorator.new(step)
    end

    def insert(index, step)
      steps.insert index, ExecutableStepDecorator.new(step)
    end

    def remove(step)
      @steps.delete_if { |decorated_step| decorated_step.step == step }
    end

    def execute(context)
      context
    end
  end
end
