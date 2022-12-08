# frozen_string_literal: true

require "expression_ast/base/unary_operator"
require "expression_ast/base/node"

RSpec.describe ExpressionAST::Base::UnaryOperator do
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
    subject(:node) { test_class.new(ExpressionAST::Base::Node.new("a")) }

    context "with result proc specified" do
      subject(:test_class) do
        Class.new(described_class) do
          token "%"
          result { |_o| "[#{operand}]" }
        end
      end

      it "passes value through result proc" do
        expect(node.result).to eql("[a]")
      end
    end

    context "without result proc" do
      subject(:test_class) do
        Class.new(described_class) do
          token "%"
        end
      end

      it "raises NotImplementedError" do
        expect { node.result }.to raise_error(NotImplementedError)
      end
    end
  end

  describe ".stringify" do
    subject(:node) { test_class.new(ExpressionAST::Base::Node.new("a")) }

    context "with stringify proc specified" do
      subject(:test_class) do
        Class.new(described_class) do
          token "%"
          stringify { |_t, _o| "#{token}[#{operand}]" }
        end
      end

      it "passes value through stringify proc" do
        expect(node.to_s).to eql("%[a]")
      end
    end

    context "without stringify proc" do
      subject(:test_class) do
        Class.new(described_class) do
          token "%"
        end
      end

      it "returns default string representation" do
        expect(node.to_s).to eql("% a")
      end
    end
  end

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

  describe "#to_h" do
    subject(:test_class) do
      Class.new(described_class) do
        token "%"
      end
    end

    subject(:node) { test_class.new(ExpressionAST::Base::Node.new("a")) }

    it "should return a Hash" do
      expect(node.to_h).to be_a(Hash)
    end

    it "should return a Hash with a type field of group" do
      expect(node.to_h).to include(type: :unary_operator)
    end

    it "should return a Hash with a token field with token as value" do
      expect(node.to_h).to include(token: node.token)
    end

    it "should return a Hash with a operand field with operand#to_h as value" do
      expect(node.to_h).to include(operand: node.operand.to_h)
    end
  end
end
