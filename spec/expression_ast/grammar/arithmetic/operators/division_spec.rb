# frozen_string_literal: true

require "expression_ast/grammar/arithmetic/operators/division"
require "expression_ast/grammar/arithmetic/node"

RSpec.describe ExpressionAST::Grammar::Arithmetic::Operators::Division do
  subject(:node) { described_class.new(left_operand, right_operand) }

  describe "#result" do
    context "with integer operands" do
      let(:left_operand) { ExpressionAST::Grammar::Arithmetic::Node.new("6") }
      let(:right_operand) { ExpressionAST::Grammar::Arithmetic::Node.new("3") }
      let(:result) { 2.0 }

      it "should div left operand by right operand" do
        expect(node.result).to eql(result)
      end
    end

    context "with float operands" do
      let(:left_operand) { ExpressionAST::Grammar::Arithmetic::Node.new("2.5") }
      let(:right_operand) { ExpressionAST::Grammar::Arithmetic::Node.new("0.5") }
      let(:result) { 5.0 }

      it "should div left operand by right operand" do
        expect(node.result).to eql(result)
      end
    end
  end

  describe "#to_s" do
    let(:left_operand) { ExpressionAST::Grammar::Arithmetic::Node.new("2") }
    let(:right_operand) { ExpressionAST::Grammar::Arithmetic::Node.new("3") }

    it "converts operator to human-readable expression" do
      expect(node.to_s).to eql("2.0 / 3.0")
    end
  end
end
