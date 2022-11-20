# frozen_string_literal: true

require "expression_ast/grammar/boolean/operators/negation"
require "expression_ast/grammar/boolean/node"

RSpec.describe ExpressionAST::Grammar::Boolean::Operators::Negation do
  subject(:node) { described_class.new(operand) }

  describe "#result" do
    context "with truthy operand" do
      let(:operand) { ExpressionAST::Grammar::Boolean::Node.new(true) }
      let(:result) { false }

      it "should NOT the operand" do
        expect(node.result).to eql(result)
      end
    end

    context "with falsey operands" do
      let(:operand) { ExpressionAST::Grammar::Boolean::Node.new(false) }
      let(:result) { true }

      it "should NOT the operand" do
        expect(node.result).to eql(result)
      end
    end
  end

  describe "#to_s" do
    let(:operand) { ExpressionAST::Grammar::Boolean::Node.new("3") }

    it "converts operator to human-readable expression" do
      expect(node.to_s).to eql("NOT 3")
    end
  end
end
