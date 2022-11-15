# frozen_string_literal: true

module ExpressionAST
  module Base
    class Node
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def result
        value
      end

      def to_s
        value.to_s
      end

      def ==(other)
        return false unless other.is_a?(self.class)

        value == other.value
      end
    end
  end
end
