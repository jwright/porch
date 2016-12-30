module Porch
  class InvalidStepTypeError < RuntimeError
    attr_reader :step

    def initialize(step)
      @step = step
      super "Step type #{step.class.name} is not handled"
    end
  end
end
