# frozen_string_literal: true

require "expression_ast/base/grammar"

module ExpressionAST
  module Grammar
    class Arithmetic < ::ExpressionAST::Base::Grammar
      literal do
        parse_value { value.to_f }
      end

      operators do # rubocop:disable Metrics/BlockLength
        grouped do
          binary_operator do
            token "^"
            result { left_operand.result**right_operand.result }
          end
        end
        grouped do
          binary_operator do
            token "*"
            result { left_operand.result * right_operand.result }
          end
          binary_operator do
            token "/"
            result { left_operand.result / right_operand.result }
          end
        end
        grouped do
          binary_operator do
            token "+"
            result { left_operand.result + right_operand.result }
          end
          binary_operator do
            token "-"
            result { left_operand.result - right_operand.result }
          end
        end
      end
    end
  end
end
