# frozen_string_literal: true

require "expression_ast/base/binary_operator"
require "expression_ast/base/node"

RSpec.describe ExpressionAST::Base::BinaryOperator do
  describe ".token" do
    subject(:test_class) do
      Class.new(described_class) do
        token "%"
      end
    end

    it "saves token" do
      expect(test_class.token).to eql("%")
    end
  end

  describe ".result" do
    subject(:node) { test_class.new(ExpressionAST::Base::Node.new("a"), ExpressionAST::Base::Node.new("b")) }

    context "with result proc specified" do
      subject(:test_class) do
        Class.new(described_class) do
          token "+"
          result { |_l, _r| "#{left_operand}#{right_operand}" }
        end
      end

      it "passes value through result proc" do
        expect(node.result).to eql("ab")
      end
    end

    context "without result proc" do
      subject(:test_class) do
        Class.new(described_class) do
          token "+"
        end
      end

      it "raises NotImplementedError" do
        expect { node.result }.to raise_error(NotImplementedError)
      end
    end
  end

  describe ".stringify" do
    subject(:node) { test_class.new(ExpressionAST::Base::Node.new("a"), ExpressionAST::Base::Node.new("b")) }

    context "with stringify proc specified" do
      subject(:test_class) do
        Class.new(described_class) do
          token "+"
          stringify { |_t, _l, _r| "#{token} #{left_operand} #{right_operand}" }
        end
      end

      it "passes value through stringify proc" do
        expect(node.to_s).to eql("+ a b")
      end
    end

    context "without stringify proc" do
      subject(:test_class) do
        Class.new(described_class) do
          token "+"
        end
      end

      it "returns default string representation" do
        expect(node.to_s).to eql("a + b")
      end
    end
  end

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
