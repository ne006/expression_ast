# frozen_string_literal: true

require "expression_ast/base/grammar"

module ExpressionAST
  module Grammar
    class Boolean < ::ExpressionAST::Base::Grammar
      literal do
        result do
          case value
          when true, "true", "TRUE" then true
          when false, "false", "FALSE", "nil", "NIL", "null", "NULL" then false
          else !value.nil?
          end
        end
      end

      operators do
        grouped do
          unary_operator do
            token "NOT"
            result { !operand.result }
          end
        end
        grouped do
          binary_operator do
            token "AND"
            result { left_operand.result && right_operand.result }
          end
        end
        grouped do
          binary_operator do
            token "OR"
            result { left_operand.result || right_operand.result }
          end
        end
      end
    end
  end
end
