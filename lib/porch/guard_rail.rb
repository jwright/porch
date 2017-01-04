module Porch
  module GuardRail
    def guard(&block)
      # Guard.new(self).against(&block)
    end

    def guard!(&block)
      # Guard.new(self, :fail!).against(&block)
    end
  end
end
