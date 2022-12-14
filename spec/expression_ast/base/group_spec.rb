# frozen_string_literal: true

require "expression_ast/base/group"
require "expression_ast/base/node"

RSpec.describe ExpressionAST::Base::Group do
  describe ".start_token" do
    context "with specified start_token" do
      subject(:test_class) do
        Class.new(described_class) do
          start_token "["
        end
      end

      it "saves start_token" do
        expect(test_class.start_token).to eql("[")
      end
    end

    context "without specified start_token" do
      subject(:test_class) { Class.new(described_class) }

      it "returns default end_token" do
        expect(test_class.start_token).to eql("(")
      end
    end
  end

  describe ".end_token" do
    context "with specified end_token" do
      subject(:test_class) do
        Class.new(described_class) do
          end_token "]"
        end
      end

      it "saves end_token" do
        expect(test_class.end_token).to eql("]")
      end
    end

    context "without specified end_token" do
      subject(:test_class) { Class.new(described_class) }

      it "returns default end_token" do
        expect(test_class.end_token).to eql(")")
      end
    end
  end

  describe ".stringify" do
    subject(:node) { test_class.new(ExpressionAST::Base::Node.new(5)) }

    context "with stringify proc specified" do
      subject(:test_class) do
        Class.new(described_class) do
          start_token "("
          end_token ")"
          stringify { |_st, _et, _v| "#{start_token} - #{value} - #{end_token}" }
        end
      end

      it "passes value through stringify proc" do
        expect(node.to_s).to eql("( - 5 - )")
      end
    end

    context "without stringify proc" do
      subject(:test_class) do
        Class.new(described_class) do
          start_token "("
          end_token ")"
        end
      end

      it "returns default string representation" do
        expect(node.to_s).to eql("( 5 )")
      end
    end
  end

  describe "#==" do
    subject(:one) { described_class.new(ExpressionAST::Base::Node.new("a")) }

    context "when values are equal" do
      subject(:another) { described_class.new(ExpressionAST::Base::Node.new("a")) }

      it "should return true" do
        expect(one).to be == another
      end
    end

    context "when values are not equal" do
      subject(:another) { described_class.new(ExpressionAST::Base::Node.new("b")) }

      it "should return false" do
        expect(one).not_to be == another
      end
    end

    context "when nodes do not belong to the same class" do
      let(:one_subclass) { Class.new(described_class) { ; } }
      let(:antoher_subclass) { Class.new(described_class) { ; } }
      subject(:one) { one_subclass.new(ExpressionAST::Base::Node.new("a")) }
      subject(:another) { antoher_subclass.new(ExpressionAST::Base::Node.new("b")) }

      it "should return false" do
        expect(one).not_to be == another
      end
    end
  end

  describe "#to_h" do
    subject(:test_class) { Class.new(described_class) }

    subject(:node) { test_class.new(ExpressionAST::Base::Node.new(5)) }

    it "should return a Hash" do
      expect(node.to_h).to be_a(Hash)
    end

    it "should return a Hash with a type field of group" do
      expect(node.to_h).to include(type: :group)
    end

    it "should return a Hash with a value field with value#to_h as value" do
      expect(node.to_h).to include(value: node.value.to_h)
    end
  end
end
