# frozen_string_literal: true

require "expression_ast/grammar/boolean/node"

RSpec.describe ExpressionAST::Grammar::Boolean::Node do
  subject(:node) { described_class.new(value) }

  describe "#result" do
    context "with String value" do
      context "with truthy value" do
        subject(:value) { "a" }

        it "casts value to Boolean" do
          expect(node.result).to be true
        end
      end

      context "with falsey value" do
        subject(:value) { "false" }

        it "casts value to Boolean" do
          expect(node.result).to be false
        end
      end
    end

    context "with nil value" do
      subject(:value) { nil }

      it "casts value to Boolean" do
        expect(node.result).to be false
      end
    end

    context "with Boolean value" do
      subject(:value) { false }

      it "casts value to Boolean" do
        expect(node.value).to be false
      end
    end
  end
end
