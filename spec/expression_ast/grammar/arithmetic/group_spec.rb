# frozen_string_literal: true

require "expression_ast/grammar/arithmetic/group"
require "expression_ast/grammar/arithmetic/node"

RSpec.describe ExpressionAST::Grammar::Arithmetic::Group do
  subject(:node) { described_class.new(value) }

  describe "#to_s" do
    context "with simple Arithmetic::Node value" do
      let(:value) { ExpressionAST::Grammar::Arithmetic::Node.new("5") }
      let(:expression) { "( 5.0 )" }

      it "converts group to human-readable expression" do
        expect(node.to_s).to eql(expression)
      end
    end

    context "with Arithmetic::Group-nested Arithmetic::Node value" do
      let(:value) { described_class.new(ExpressionAST::Grammar::Arithmetic::Node.new("5")) }
      let(:expression) { "( ( 5.0 ) )" }

      it "converts group to human-readable expression" do
        expect(node.to_s).to eql(expression)
      end
    end
  end
end
