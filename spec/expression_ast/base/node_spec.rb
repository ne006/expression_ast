# frozen_string_literal: true

require "expression_ast/base/node"

RSpec.describe ExpressionAST::Base::Node do
  describe ".parse_value" do
    subject(:node) { test_class.new(5) }

    context "with value parser proc specified" do
      subject(:test_class) do
        Class.new(described_class) do
          parse_value { |_v| "[#{value}]" }
        end
      end

      it "parses value on initialization" do
        expect(node.value).to eql("[5]")
      end
    end

    context "without value parser proc" do
      subject(:test_class) do
        Class.new(described_class)
      end

      it "saves value as-is" do
        expect(node.value).to eql(5)
      end
    end
  end

  describe ".result" do
    subject(:node) { test_class.new(5) }

    context "with result proc specified" do
      subject(:test_class) do
        Class.new(described_class) do
          result { |_v| "[#{value}]" }
        end
      end

      it "passes value through result proc" do
        expect(node.result).to eql("[5]")
      end
    end

    context "without result proc" do
      subject(:test_class) do
        Class.new(described_class)
      end

      it "returns value as-is" do
        expect(node.value).to eql(5)
      end
    end
  end

  describe ".stringify" do
    subject(:node) { test_class.new(5) }

    context "with stringify proc specified" do
      subject(:test_class) do
        Class.new(described_class) do
          stringify { |value| "[#{value}]" }
        end
      end

      it "passes value through stringify proc" do
        expect(node.to_s).to eql("[5]")
      end
    end

    context "without stringify proc" do
      subject(:test_class) do
        Class.new(described_class)
      end

      it "returns result of value.to_s" do
        expect(node.to_s).to eql("5")
      end
    end
  end

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

  describe "#to_h" do
    subject(:test_class) { Class.new(described_class) }

    subject(:node) { test_class.new(5) }

    it "should return a Hash" do
      expect(node.to_h).to be_a(Hash)
    end

    it "should return a Hash with a type field of node" do
      expect(node.to_h).to include(type: :node)
    end

    it "should return a Hash with a value field" do
      expect(node.to_h).to include(value: 5)
    end
  end
end
