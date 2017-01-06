module Porch
  class ContextFailedError < RuntimeError
    attr_reader :context

    def initialize(context)
      @context = context
    end
  end
end
