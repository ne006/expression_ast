# frozen_string_literal: true

require "expression_ast/base/lexer"

require "expression_ast/base/node"
require "expression_ast/base/group"

require "expression_ast/base/binary_operator"
require "expression_ast/base/unary_operator"

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

        def operators(&def_proc)
          if block_given?
            @operators = []

            instance_exec(&def_proc)
          else
            (@operators ||= []).tap do |l|
              def l.find_by_token(token)
                reduce(nil) do |res, group|
                  break res if (res = group.find { _1.token == token })
                end
              end
            end
          end
        end

        protected

        def grouped(&def_proc)
          @operators << OperatorGrouper.new.call(&def_proc)
        end
      end

      class OperatorGrouper
        def initialize
          @operators = []
        end

        def call(&def_proc)
          instance_exec(&def_proc)
          @operators
        end

        protected

        def binary_operator(operator_class = nil, &def_proc)
          raise ArgumentError unless operator_class || def_proc

          @operators << if def_proc
                          Class.new(operator_class || ExpressionAST::Base::BinaryOperator, &def_proc)
                        else
                          operator_class
                        end
        end

        def unary_operator(operator_class = nil, &def_proc)
          raise ArgumentError unless operator_class || def_proc

          @operators << if def_proc
                          Class.new(operator_class || ExpressionAST::Base::UnaryOperator, &def_proc)
                        else
                          operator_class
                        end
        end
      end
    end
  end
end
