# frozen_string_literal: true

require "expression_ast/base/binary_operator"
require "expression_ast/base/unary_operator"

module ExpressionAST
  class Parser
    attr_reader :grammar

    def initialize(grammar)
      @grammar = grammar
    end

    def build_expression_ast(expression)
      tokens = grammar.lexer.new(expression).tokens

      build_node_from_tokens(tokens)
    end

    protected

    def build_node_from_tokens(tokens)
      if group?(tokens)
        parse_group(tokens)
      elsif operator?(tokens)
        parse_operator(tokens)
      else
        parse_value(tokens)
      end
    end

    def operator?(tokens)
      (tokens & grammar.operators.flatten.map(&:value)).any?
    end

    def parse_operator(tokens) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
      operator_index = -1

      grammar.operators.reverse.each do |operator_group|
        break if operator_index && operator_index != -1

        operator_index = operator_group.map do |operator|
          int_idx = -1

          tokens.each_with_index do |token, idx|
            next unless token == operator.value

            groups_closed = (
              tokens.slice(0..idx).select { |t| t == grammar.group.start_token }.size ==
              tokens.slice(0..idx).select { |t| t == grammar.group.end_token }.size
            )

            if idx && groups_closed
              int_idx = idx
              break
            end
          end

          int_idx
        end.compact.reject(&:negative?).min
      end

      if operator_index && operator_index != -1
        value = tokens[operator_index]
        left_operand = build_node_from_tokens(tokens.slice(0...operator_index))
        right_operand = build_node_from_tokens(tokens.slice((operator_index + 1)..-1))

        operator_klass = resolve_operator(value)

        if operator_klass.ancestors.include? ExpressionAST::Base::BinaryOperator
          operator_klass&.new(left_operand, right_operand)
        elsif operator_klass.ancestors.include? ExpressionAST::Base::UnaryOperator
          operator_klass&.new(right_operand)
        end
      else
        grammar.literal.new(nil)
      end
    end

    def group?(tokens)
      tokens.first == grammar.group.start_token && tokens.last == grammar.group.end_token
    end

    def parse_group(tokens)
      grammar.group.new(build_node_from_tokens(tokens.slice(1...-1)))
    end

    def parse_value(tokens)
      grammar.literal.new(tokens.join(" "))
    end

    def resolve_operator(operator_token)
      operator_klass = nil

      grammar.operators.each do |operator_group|
        operator_klass = operator_group.find { |o| o.value == operator_token }

        break if operator_klass
      end

      operator_klass
    end
  end
end
