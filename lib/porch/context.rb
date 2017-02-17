require "porch/guard_rail"

module Porch
  class Context < Hash
    include Porch::GuardRail

    attr_reader :message

    def initialize(context={}, success=true)
      @message = nil
      @success = success
      @skip_remaining = false
      deep_duplicate(context)
    end

    def deep_dup
      self.class.new(self, self.success?)
    end

    def fail!(message="")
      @message = message
      @success = false
      raise Porch::ContextStoppedError.new(self)
    end

    def failure?
      !success?
    end

    def guard_with_skipping(&block)
      result = guard &block
      skip_remaining! if result.failure?
      result
    end

    def guard_with_failure(&block)
      result = guard &block
      fail!(HumanError.new(result.errors).message) if result.failure?
      result
    end

    def method_missing(name, *args, &block)
      return fetch(name) if key?(name)
      super
    end

    def skip_next(&block)
      result = Guard.new(self).against(&block)
      raise Porch::ContextStoppedError.new(self) if result.failure?
      result
    end

    def skip_remaining?
      !!@skip_remaining
    end

    def skip_remaining!
      @skip_remaining = true
      raise Porch::ContextStoppedError.new(self)
    end

    def success?
      @success
    end

    def stop_processing?
      failure? || skip_remaining?
    end

    private

    def deep_duplicate(context)
      (context || {}).to_hash.each { |k, v| self[k] = v }
      self
    end
  end
end
