module Porch
  class StepChain
    attr_reader :organizer, :steps

    def initialize(organizer)
      @organizer = organizer
      @steps = []
    end

    def add(step=nil, &block)
      step = block if block_given?
      steps << ExecutableStepDecorator.new(step, organizer)
    end

    def insert(index, step=nil, &block)
      step = block if block_given?
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
