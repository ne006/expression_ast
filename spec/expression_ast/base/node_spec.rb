# frozen_string_literal: true

require "expression_ast/base/node"

RSpec.describe ExpressionAST::Base::Node do
  describe "#==" do
    subject(:one) { described_class.new("a") }

    context "when values are equal" do
      subject(:another) { described_class.new("a") }

      it "should return true" do
        expect(one).to be == another
      end
    end

    context "when values are not equal" do
      subject(:another) { described_class.new("b") }

      it "should return false" do
        expect(one).not_to be == another
      end
    end

    context "when nodes do not belong to the same class" do
      let(:one_subclass) { Class.new(described_class) { ; } }
      let(:antoher_subclass) { Class.new(described_class) { ; } }
      subject(:one) { one_subclass.new("a") }
      subject(:another) { antoher_subclass.new("b") }

      it "should return false" do
        expect(one).not_to be == another
      end
    end
  end
end
