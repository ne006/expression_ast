# frozen_string_literal: true

require "expression_ast/base/unary_operator"

module ExpressionAST
  module Grammar
    module Boolean
      module Operators
        class Negation < ExpressionAST::Base::UnaryOperator
          def self.token
            "NOT"
          end

          def result
            !operand.result
          end
        end
      end
    end
  end
end
