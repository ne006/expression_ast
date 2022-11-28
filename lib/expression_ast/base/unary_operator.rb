# frozen_string_literal: true

require "expression_ast/base/node"

module ExpressionAST
  module Base
    class UnaryOperator
      attr_reader :operand

      class << self
        def value
          raise NotImplementedError
        end

        def token
          value
        end
      end

      def initialize(operand)
        @operand = operand
      end

      def value
        self.class.value
      end

      def result
        raise NotImplementedError
      end

      def to_s
        "#{value} #{operand}"
      end

      def ==(other)
        return false unless other.is_a?(self.class)

        operand == other.operand
      end
    end
  end
end
