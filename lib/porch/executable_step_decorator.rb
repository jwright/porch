require_relative "step_decorators/class_step_decorator"
require_relative "step_decorators/method_step_decorator"
require_relative "step_decorators/proc_step_decorator"

module Porch
  class ExecutableStepDecorator
    attr_reader :decorated_step

    def step
      decorated_step.step
    end

    def initialize(step, organizer)
      @decorated_step = decorate step, organizer
    end

    def execute(context)
      begin
        decorated_step.execute context
      rescue Porch::ContextStoppedError => e
        # this exception is just used for flow control
        e.context
      end
    end

    def self.registered_decorators
      [ClassStepDecorator, MethodStepDecorator, ProcStepDecorator].freeze
    end

    private

    def decorate(step, organizer)
      decorator = self.class.registered_decorators.find { |d| d.decorates?(step) }
      raise InvalidStepTypeError.new(step) if decorator.nil?
      decorator.new(step, organizer)
    end
  end
end
