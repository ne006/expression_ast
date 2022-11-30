# frozen_string_literal: true

module ExpressionAST
  module Grammar
    module Boolean
      class Lexer
        attr_reader :grammar

        def initialize(grammar)
          @grammar = grammar
        end

        def tokens(expression) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
          return @tokens if @tokens

          @tokens = []

          last_expr = expression.each_char.reduce(String.new) do |curr_expr, char|
            case char
            when " "
              @tokens << curr_expr if curr_expr != ""
              String.new
            when grammar.group.start_token
              @tokens << char
              String.new
            when grammar.group.end_token, *grammar.operators.flatten.map(&:token)
              @tokens << curr_expr if curr_expr != ""
              @tokens << char
              String.new
            else
              curr_expr << char
            end
          end

          @tokens << last_expr if last_expr != ""

          @tokens
        end
      end
    end
  end
end
