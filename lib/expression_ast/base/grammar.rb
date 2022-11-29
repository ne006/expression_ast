# frozen_string_literal: true

require "expression_ast/base/lexer"
require "expression_ast/base/node"
require "expression_ast/base/group"

module ExpressionAST
  module Base
    class Grammar
      class << self
        def lexer(lexer = nil)
          return @lexer if @lexer

          @lexer = lexer || ExpressionAST::Base::Lexer
        end

        def literal(literal_class = nil, &def_proc)
          return @literal if @literal

          @literal =
            if def_proc
              Class.new(literal_class || ExpressionAST::Base::Node, &def_proc)
            else
              literal_class || ExpressionAST::Base::Node
            end
        end

        def group(group_class = nil, &def_proc)
          return @group if @group

          @group =
            if def_proc
              Class.new(group_class || ExpressionAST::Base::Group, &def_proc)
            else
              group_class || ExpressionAST::Base::Group
            end
        end
      end
    end
  end
end
