# frozen_string_literal: true

require "expression_ast/base/group"

module ExpressionAST
  module Grammar
    module Arithmetic
      class Group < ExpressionAST::Base::Group
        class << self
          def start_token
            "("
          end

          def end_token
            ")"
          end
        end
      end
    end
  end
end
