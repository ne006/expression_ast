# frozen_string_literal: true

module ExpressionAST
  module Base
    class Node
      class << self
        def parse_value(&block)
          return @parse_value unless block_given?

          @parse_value = block
        end

        def result(&block)
          return @result unless block_given?

          @result = block
        end

        def stringify(&block)
          return @stringify unless block_given?

          @stringify = block
        end
      end

      attr_reader :value

      def initialize(value)
        @value = self.class.parse_value ? self.class.parse_value.call(value) : value
      end

      def result
        self.class.result ? self.class.result.call(value) : value
      end

      def to_s
        self.class.stringify ? self.class.stringify.call(value) : value.to_s
      end

      def ==(other)
        return false unless other.is_a?(self.class)

        value == other.value
      end
    end
  end
end
