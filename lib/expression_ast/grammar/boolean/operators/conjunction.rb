# frozen_string_literal: true

require "expression_ast/base/binary_operator"

module ExpressionAST
  module Grammar
    module Boolean
      module Operators
        class Conjunction < ExpressionAST::Base::BinaryOperator
          def self.token
            "AND"
          end

          def result
            left_operand.result && right_operand.result
          end
        end
      end
    end
  end
end
