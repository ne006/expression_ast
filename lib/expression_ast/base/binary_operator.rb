# frozen_string_literal: true

require "expression_ast/base/node"

module ExpressionAST
  module Base
    class BinaryOperator
      attr_reader :left_operand, :right_operand

      def self.value
        raise NotImplemented
      end

      def initialize(left_operand, right_operand)
        @left_operand = left_operand
        @right_operand = right_operand
      end

      def value
        self.class.value
      end

      def result
        raise NotImplemented
      end

      def to_s
        "#{left_operand} #{value} #{right_operand}"
      end

      def ==(other)
        return false unless other.is_a?(self.class)

        left_operand == other.left_operand && right_operand == other.right_operand
      end
    end
  end
end
