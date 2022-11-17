# frozen_string_literal: true

require "expression_ast/base/node"

module ExpressionAST
  module Grammar
    module Arithmetic
      class Node < ExpressionAST::Base::Node
        def initialize(value)
          super

          @value = value.to_f
        end
      end
    end
  end
end
