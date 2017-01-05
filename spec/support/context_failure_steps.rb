module Porch
  module SpecHelper
    module ContextFailureExample
      def wrap_skipping_step_catch(example)
        catch :stop_current_step_execution do
          example.run
        end
      end
    end
  end
end
