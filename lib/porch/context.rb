module Porch
  class Context < Hash
    def initialize(context={}, success=true)
      @success = success
      deep_duplicate(context)
    end

    def deep_dup
      self.class.new(self, self.success?)
    end

    def failure?
      !success?
    end

    def success?
      @success
    end

    private

    def deep_duplicate(context)
      (context || {}).to_hash.each { |k, v| self[k] = v }
      self
    end
  end
end
