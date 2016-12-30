module Porch
  module Organizer
    attr_reader :context

    def with(parameters={})
      @context = Context.new parameters

      chain = StepChain.new
      yield chain if block_given?

      chain.execute context
    end
  end
end
