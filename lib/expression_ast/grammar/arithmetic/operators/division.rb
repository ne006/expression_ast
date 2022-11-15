# frozen_string_literal: true

require "expression_ast/base/binary_operator"

module ExpressionAST
  module Grammar
    module Arithmetic
      module Operators
        class Division < ExpressionAST::Base::BinaryOperator
          def self.value
            "/"
          end

          def result
            left_operand.result / right_operand.result
          end
        end
      end
    end
  end
end
