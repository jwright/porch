module Porch
  class Context < Hash
    def initialize(context={})
      deep_duplicate(context)
    end

    def deep_dup
      self.class.new(self)
    end

    private

    def deep_duplicate(context)
      (context || {}).to_hash.each { |k, v| self[k] = v }
      self
    end
  end
end
