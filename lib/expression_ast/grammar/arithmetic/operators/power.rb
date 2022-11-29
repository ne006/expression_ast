# frozen_string_literal: true

require "expression_ast/base/binary_operator"

module ExpressionAST
  module Grammar
    class Arithmetic < ::ExpressionAST::Base::Grammar
      module Operators
        class Power < ExpressionAST::Base::BinaryOperator
          def self.token
            "^"
          end

          def result
            left_operand.result**right_operand.result
          end
        end
      end
    end
  end
end
