require_relative "guard_rail/guard"

module Porch
  module GuardRail
    def guard(&block)
      Guard.new(self).against(&block)
    end
  end
end
