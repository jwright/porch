module Porch
  class ClassStepDecorator
    attr_reader :step

    def initialize(step, _organizer)
      @step = step
    end

    def execute(context)
      ctx = Context.new(context)
      step.new.call ctx
      ctx
    end

    def self.decorates?(step)
      step.is_a? Class
    end
  end
end
