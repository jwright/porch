module Porch
  module CoreExt
    class String
      CAPITALIZE_SEPARATOR = ' '.freeze
      CLASSIFY_SEPARATOR  = '_'.freeze
      NAMESPACE_SEPARATOR = '::'.freeze
      UNDERSCORE_DIVISION_TARGET = '\1_\2'.freeze
      UNDERSCORE_SEPARATOR = '/'.freeze

      def initialize(string)
        @string = string.to_s
      end

      def capitalize
        head, *tail = underscore.split(CLASSIFY_SEPARATOR)

        self.class.new tail.unshift(head.capitalize).join(CAPITALIZE_SEPARATOR)
      end

      def gsub(pattern, replacement=nil, &blk)
        if block_given?
          string.gsub(pattern, &blk)
        else
          string.gsub(pattern, replacement)
        end
      end

      def split(pattern, limit=0)
        string.split(pattern, limit)
      end

      def to_s
        string
      end

      def underscore
        new_string = gsub(NAMESPACE_SEPARATOR, UNDERSCORE_SEPARATOR)
        new_string.gsub!(/([A-Z\d]+)([A-Z][a-z])/, UNDERSCORE_DIVISION_TARGET)
        new_string.gsub!(/([a-z\d])([A-Z])/, UNDERSCORE_DIVISION_TARGET)
        new_string.gsub!(/[[:space:]]|\-/, UNDERSCORE_DIVISION_TARGET)
        new_string.downcase!
        self.class.new new_string
      end

      def ==(other)
        to_s == other
      end
      alias eql? ==

      private

      attr_reader :string
    end
  end
end
