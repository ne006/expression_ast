# frozen_string_literal: true

require "expression_ast/grammar/arithmetic/node"

RSpec.describe ExpressionAST::Grammar::Arithmetic::Node do
  subject(:node) { described_class.new(value) }

  describe "#initialize" do
    context "with String value" do
      subject(:value) { "5" }

      it "casts value to Float" do
        expect(node.value).to eql(5.0)
      end
    end

    context "with Integer value" do
      subject(:value) { 5 }

      it "casts value to Float" do
        expect(node.value).to eql(5.0)
      end
    end

    context "with Float value" do
      subject(:value) { 5.0 }

      it "casts value to Float" do
        expect(node.value).to eql(5.0)
      end
    end
  end
end
