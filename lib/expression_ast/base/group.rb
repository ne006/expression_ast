# frozen_string_literal: true

require "expression_ast/base/node"

module ExpressionAST
  module Base
    class Group < Node
      class << self
        def start_token(token = nil)
          return @start_token if token.nil?

          @start_token = token
        end

        def end_token(token = nil)
          return @end_token if token.nil?

          @end_token = token
        end

        def stringify(&block)
          return @stringify unless block_given?

          @stringify = block
        end
      end

      def start_token
        self.class.start_token
      end

      def end_token
        self.class.end_token
      end

      def result
        value.result
      end

      def to_s
        if self.class.stringify
          instance_exec(self.class.start_token, self.class.end_token, value, &self.class.stringify)
        else
          "#{self.class.start_token} #{value} #{self.class.end_token}"
        end
      end

      def ==(other)
        return false unless other.is_a?(self.class)

        value == other.value
      end
    end
  end
end
