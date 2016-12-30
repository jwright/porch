module Porch
  class StepChain
    attr_reader :steps

    def initialize
      @steps = []
    end

    def add(step)
      steps << step
    end

    def insert(index, step)
      steps.insert index, step
    end

    def remove(step)
      @steps.delete step
    end

    def execute(context)
      context
    end
  end
end
