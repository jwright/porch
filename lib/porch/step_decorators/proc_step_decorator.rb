module Porch
  class ProcStepDecorator
    attr_reader :step

    def initialize(step)
      @step = step
    end

    def self.decorates?(step)
      step.is_a? Proc
    end
  end
end