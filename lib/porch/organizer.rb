module Porch
  module Organizer
    attr_reader :context

    def with(parameters={})
      @context = Context.new parameters

      context
    end
  end
end
