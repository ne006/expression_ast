# frozen_string_literal: true

require "expression_ast/base/binary_operator"
require "expression_ast/base/node"

RSpec.describe ExpressionAST::Base::BinaryOperator do
  describe "#==" do
    subject(:one) { described_class.new(ExpressionAST::Base::Node.new("a"), ExpressionAST::Base::Node.new("b")) }

    context "when values are equal" do
      subject(:another) { described_class.new(ExpressionAST::Base::Node.new("a"), ExpressionAST::Base::Node.new("b")) }

      it "should return true" do
        expect(one).to be == another
      end
    end

    context "when values are not equal" do
      subject(:another) { described_class.new(ExpressionAST::Base::Node.new("b"), ExpressionAST::Base::Node.new("c")) }

      it "should return false" do
        expect(one).not_to be == another
      end
    end

    context "when nodes do not belong to the same class" do
      let(:one_subclass) { Class.new(described_class) { ; } }
      let(:antoher_subclass) { Class.new(described_class) { ; } }
      subject(:one) { one_subclass.new(ExpressionAST::Base::Node.new("a"), ExpressionAST::Base::Node.new("b")) }
      subject(:another) { antoher_subclass.new(ExpressionAST::Base::Node.new("a"), ExpressionAST::Base::Node.new("b")) }

      it "should return false" do
        expect(one).not_to be == another
      end
    end
  end
end
