module Porch
  class ClassStepDecorator
    attr_reader :step

    def initialize(step)
      @step = step
    end

    def execute(context)
      Context.new(context)
    end

    def self.decorates?(step)
      step.is_a? Class
    end
  end
end
