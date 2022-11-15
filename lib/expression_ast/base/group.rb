# frozen_string_literal: true

require "expression_ast/base/node"

module ExpressionAST
  module Base
    class Group < Node
      class << self
        def start_token
          raise NotImplemented
        end

        def end_token
          raise NotImplemented
        end
      end

      def result
        value.result
      end

      def to_s
        "#{self.class.start_token} #{value} #{self.class.end_token}"
      end

      def ==(other)
        return false unless other.is_a?(self.class)

        value == other.value
      end
    end
  end
end
