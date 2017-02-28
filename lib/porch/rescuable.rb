module Porch
  module Rescuable
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def rescue_from(*klasses, with: nil, &block)
      end
    end
  end
end
