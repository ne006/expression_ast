# frozen_string_literal: true

require "expression_ast/base/node"

module ExpressionAST
  module Base
    class UnaryOperator
      attr_reader :operand

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

      def initialize(operand)
        @operand = operand
      end

      def token
        self.class.token
      end

      def result
        raise NotImplementedError unless self.class.result

        self.class.result.call(operand)
      end

      def to_s
        if self.class.stringify
          self.class.stringify.call(self.class.token, operand)
        else
          "#{self.class.token} #{operand}"
        end
      end

      def ==(other)
        return false unless other.is_a?(self.class)

        operand == other.operand
      end
    end
  end
end
