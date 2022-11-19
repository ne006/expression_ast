# frozen_string_literal: true

require "expression_ast/grammar/boolean/group"
require "expression_ast/grammar/boolean/node"

RSpec.describe ExpressionAST::Grammar::Boolean::Group do
  subject(:node) { described_class.new(value) }

  describe "#to_s" do
    context "with simple Boolean::Node value" do
      let(:value) { ExpressionAST::Grammar::Boolean::Node.new(true) }
      let(:expression) { "( true )" }

      it "converts group to human-readable expression" do
        expect(node.to_s).to eql(expression)
      end
    end

    context "with Boolean::Group-nested Arithmetic::Node value" do
      let(:value) { described_class.new(ExpressionAST::Grammar::Boolean::Node.new("5")) }
      let(:expression) { "( ( 5 ) )" }

      it "converts group to human-readable expression" do
        expect(node.to_s).to eql(expression)
      end
    end
  end
end
