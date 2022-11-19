# frozen_string_literal: true

require "expression_ast/grammar/boolean/operators/conjunction"
require "expression_ast/grammar/boolean/node"

RSpec.describe ExpressionAST::Grammar::Boolean::Operators::Conjunction do
  subject(:node) { described_class.new(left_operand, right_operand) }

  describe "#result" do
    context "with truthy operands" do
      let(:left_operand) { ExpressionAST::Grammar::Boolean::Node.new(true) }
      let(:right_operand) { ExpressionAST::Grammar::Boolean::Node.new(true) }
      let(:result) { true }

      it "should AND left operand and right operand" do
        expect(node.result).to eql(result)
      end
    end

    context "with falsey operands" do
      let(:left_operand) { ExpressionAST::Grammar::Boolean::Node.new(false) }
      let(:right_operand) { ExpressionAST::Grammar::Boolean::Node.new(false) }
      let(:result) { false }

      it "should AND left operand and right operand" do
        expect(node.result).to eql(result)
      end
    end
  end

  describe "#to_s" do
    let(:left_operand) { ExpressionAST::Grammar::Boolean::Node.new("2") }
    let(:right_operand) { ExpressionAST::Grammar::Boolean::Node.new("3") }

    it "converts operator to human-readable expression" do
      expect(node.to_s).to eql("2 AND 3")
    end
  end
end
