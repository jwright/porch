module Porch
  class ContextStoppedError < RuntimeError
    attr_reader :context

    def initialize(context)
      @context = context
    end
  end
end
