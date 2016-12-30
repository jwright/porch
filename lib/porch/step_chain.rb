module Porch
  class StepChain
    attr_reader :organizer, :steps

    def initialize(organizer)
      @organizer = organizer
      @steps = []
    end

    def add(step)
      steps << ExecutableStepDecorator.new(step, organizer)
    end

    def insert(index, step)
      steps.insert index, ExecutableStepDecorator.new(step, organizer)
    end

    def remove(step)
      @steps.delete_if { |decorated_step| decorated_step.step == step }
    end

    def execute(context)
      ctx = Context.new context
      steps.map { |step| step.execute ctx }.last || ctx
    end
  end
end
