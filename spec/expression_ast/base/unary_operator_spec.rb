# frozen_string_literal: true

require "expression_ast/base/unary_operator"
require "expression_ast/base/node"

RSpec.describe ExpressionAST::Base::UnaryOperator do
  describe "#==" do
    subject(:one) { described_class.new(ExpressionAST::Base::Node.new("a")) }

    context "when operands are equal" do
      subject(:another) { described_class.new(ExpressionAST::Base::Node.new("a")) }

      it "should return true" do
        expect(one).to be == another
      end
    end

    context "when operands are not equal" do
      subject(:another) { described_class.new(ExpressionAST::Base::Node.new("b")) }

      it "should return false" do
        expect(one).not_to be == another
      end
    end

    context "when nodes do not belong to the same class" do
      let(:one_subclass) { Class.new(described_class) { ; } }
      let(:antoher_subclass) { Class.new(described_class) { ; } }
      subject(:one) { one_subclass.new(ExpressionAST::Base::Node.new("a")) }
      subject(:another) { antoher_subclass.new(ExpressionAST::Base::Node.new("a")) }

      it "should return false" do
        expect(one).not_to be == another
      end
    end
  end
end
