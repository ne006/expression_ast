# frozen_string_literal: true

require "expression_ast/base/node"

module ExpressionAST
  module Base
    class BinaryOperator
      attr_reader :left_operand, :right_operand

      class << self
        def token(token = nil)
          return @token if token.nil?

          @token = token
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

      def initialize(left_operand, right_operand)
        @left_operand = left_operand
        @right_operand = right_operand
      end

      def token
        self.class.token
      end

      def result
        raise NotImplementedError unless self.class.result

        instance_exec(left_operand, right_operand, &self.class.result)
      end

      def to_s
        if self.class.stringify
          instance_exec(self.class.token, left_operand, right_operand, &self.class.stringify)
        else
          "#{left_operand} #{self.class.token} #{right_operand}"
        end
      end

      def ==(other)
        return false unless other.is_a?(self.class)

        left_operand == other.left_operand && right_operand == other.right_operand
      end
    end
  end
end
