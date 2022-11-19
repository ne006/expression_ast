# frozen_string_literal: true

require "expression_ast/grammar/arithmetic/lexer"

require "expression_ast/grammar/arithmetic/node"
require "expression_ast/grammar/arithmetic/group"

require "expression_ast/grammar/arithmetic/operators/multiplication"
require "expression_ast/grammar/arithmetic/operators/division"
require "expression_ast/grammar/arithmetic/operators/addition"
require "expression_ast/grammar/arithmetic/operators/substraction"
require "expression_ast/grammar/arithmetic/operators/power"

module ExpressionAST
  module Grammar
    module Arithmetic
      class << self
        def lexer
          ExpressionAST::Grammar::Arithmetic::Lexer
        end

        def literal
          ExpressionAST::Grammar::Arithmetic::Node
        end

        def group
          ExpressionAST::Grammar::Arithmetic::Group
        end

        def operators
          [
            [self::Operators::Power],
            [self::Operators::Multiplication, self::Operators::Division],
            [self::Operators::Addition, self::Operators::Substraction]
          ]
        end
      end
    end
  end
end
