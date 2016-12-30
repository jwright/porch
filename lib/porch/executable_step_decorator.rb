require_relative "step_decorators/class_step_decorator"
require_relative "step_decorators/method_step_decorator"
require_relative "step_decorators/proc_step_decorator"

module Porch
  class ExecutableStepDecorator
    attr_reader :decorated_step

    def step
      decorated_step.step
    end

    def initialize(step)
      @decorated_step = decorate step
    end

    def self.registered_decorators
      [ClassStepDecorator, MethodStepDecorator, ProcStepDecorator].freeze
    end

    private

    def decorate(step)
      decorator = self.class.registered_decorators.find { |d| d.decorates?(step) }
      decorator.new(step)
    end
  end
end
