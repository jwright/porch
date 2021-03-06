module Porch
  module Rescuable
    def handle_exceptions
      yield if block_given?
    rescue Exception => e
      rescue_with_handler(e) || raise(e)
    end

    def handler_for_rescue(exception)
      _, handler = self.class.rescue_handlers.detect do |exception_class, _|
        exception_class === exception
      end

      handler
    end

    def rescue_with_handler(exception)
      handler = handler_for_rescue(exception)
      unless handler.nil?
        case handler
        when Symbol
          self.method(handler).call exception
        when Proc
          self.instance_exec exception, &handler
        end

        exception
      end
    end

    module ClassMethods
      def rescue_from(*klasses, with: nil, &block)
        handler = block_given? ? block : with
        raise ArgumentError, \
          "Requires a handler. Use the with keyword argument or supply a block." \
          if handler.nil?

        klasses.each do |klass|
          rescue_handlers << [klass, handler]
        end
      end

      def rescue_handlers
        @rescue_handlers ||= []
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
