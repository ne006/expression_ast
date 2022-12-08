# frozen_string_literal: true

module ExpressionAST
  module Base
    class Node
      class << self
        def parse_value(&block)
          return @parse_value unless block_given?

          @parse_value = block
        end

        def result(&block)
          return @result unless block_given?

          @result = block
        end

        def stringify(&block)
          return @stringify unless block_given?

          @stringify = block
        end
      end

      attr_reader :value

      def initialize(value)
        @value = value

        return unless self.class.parse_value

        @value = instance_exec(value, &self.class.parse_value)
      end

      def result
        return value unless self.class.result

        instance_exec(value, &self.class.result)
      end

      def to_s
        return value.to_s unless self.class.stringify

        instance_exec(value, &self.class.stringify)
      end

      def to_h
        { type: :node, value: value }
      end

      def ==(other)
        return false unless other.is_a?(self.class)

        value == other.value
      end
    end
  end
end
