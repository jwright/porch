module Porch
  class HumanError
    attr_accessor :seperator
    attr_reader :errors

    def initialize(errors, seperator=", ")
      @errors = errors
      @seperator = seperator
    end

    def message
      collect_messages(errors).join(seperator)
    end

    private

    def collect_messages(error_hash, attribute_prefix=nil)
      error_hash.collect do |attribute, descriptions|
        if descriptions.is_a? Hash
          collect_messages descriptions, attribute
        else
          append_message attribute_prefix, attribute, descriptions
        end
      end
    end

    def append_message(attribute_prefix, attribute, descriptions)
      append_descriptions(humanize(attribute_prefix, attribute), descriptions)
    end

    def append_descriptions(attribute, descriptions)
      descriptions.collect { |description| "#{attribute} #{description}" }.join(seperator)
    end

    def humanize(attribute_prefix, attribute)
      capitalize("#{attribute_prefix} #{attribute}".lstrip)
    end

    def capitalize(string)
      CoreExt::String.new(string).capitalize
    end
  end
end
