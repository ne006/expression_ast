# frozen_string_literal: true

require "expression_ast/base/node"

module ExpressionAST
  module Grammar
    class Boolean < ::ExpressionAST::Base::Grammar
      class Node < ExpressionAST::Base::Node
        def initialize(value)
          super

          @value = value
        end

        def result
          case value
          when "true", "TRUE" then true
          when "false", "FALSE", "nil", "NIL", "null", "NULL" then false
          else !!value
          end
        end
      end
    end
  end
end
