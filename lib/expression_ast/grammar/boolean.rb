# frozen_string_literal: true

require "expression_ast/grammar/boolean/lexer"

require "expression_ast/grammar/boolean/node"
require "expression_ast/grammar/boolean/group"

require "expression_ast/grammar/boolean/operators/conjunction"
require "expression_ast/grammar/boolean/operators/disjunction"

module ExpressionAST
  module Grammar
    module Boolean
      class << self
        def lexer
          ExpressionAST::Grammar::Boolean::Lexer
        end

        def literal
          ExpressionAST::Grammar::Boolean::Node
        end

        def group
          ExpressionAST::Grammar::Boolean::Group
        end

        def operators
          [
            [self::Operators::Conjunction],
            [self::Operators::Disjunction]
          ]
        end
      end
    end
  end
end
