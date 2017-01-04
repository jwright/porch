require "porch/guard_rail"

module Porch
  class Context < Hash
    include Porch::GuardRail

    attr_reader :message

    def initialize(context={}, success=true)
      @message = nil
      @success = success
      deep_duplicate(context)
    end

    def deep_dup
      self.class.new(self, self.success?)
    end

    def fail!(message="")
      @message = message
      @success = false
    end

    def failure?
      !success?
    end

    def guard!(&block)
      result = guard &block
      fail!(HumanError.new(result.errors).message) if result.failure?
      result
    end

    def method_missing(name, *args, &block)
      return fetch(name) if key?(name)
      super
    end

    def success?
      @success
    end

    def stop_processing?
      failure?
    end

    private

    def deep_duplicate(context)
      (context || {}).to_hash.each { |k, v| self[k] = v }
      self
    end
  end
end
