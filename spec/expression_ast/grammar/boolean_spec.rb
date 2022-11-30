# frozen_string_literal: true

require "expression_ast/grammar/boolean"

RSpec.describe ExpressionAST::Grammar::Boolean do
  subject(:grammar) { described_class }

  describe ".lexer" do
    it "should return Base::Lexer" do
      expect(grammar.lexer).to be(ExpressionAST::Base::Lexer)
    end
  end

  describe ".literal" do
    subject(:node) { described_class.literal.new(value) }

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

  describe ".group" do
    subject(:node) { described_class.group.new(value) }

    describe "#to_s" do
      context "with simple literal value" do
        let(:value) { described_class.literal.new(true) }
        let(:expression) { "( true )" }

        it "converts group to human-readable expression" do
          expect(node.to_s).to eql(expression)
        end
      end

      context "with group-nested literal value" do
        let(:value) { described_class.group.new(described_class.literal.new("5")) }
        let(:expression) { "( ( 5 ) )" }

        it "converts group to human-readable expression" do
          expect(node.to_s).to eql(expression)
        end
      end
    end
  end

  describe ".operators" do
    it "should return Boolean operators grouped by their priority" do
      expect(described_class.operators.map { _1.map(&:token) }).to eql(
        [%w[NOT], %w[AND], %w[OR]]
      )
    end

    describe "AND" do
      subject(:operator_class) { described_class.operators.find_by_token("AND") }
      subject(:node) { operator_class.new(left_operand, right_operand) }

      describe "#result" do
        context "with truthy operands" do
          let(:left_operand) { described_class.literal.new(true) }
          let(:right_operand) { described_class.literal.new(true) }
          let(:result) { true }

          it "should AND left operand and right operand" do
            expect(node.result).to eql(result)
          end
        end

        context "with falsey operands" do
          let(:left_operand) { described_class.literal.new(false) }
          let(:right_operand) { described_class.literal.new(false) }
          let(:result) { false }

          it "should AND left operand and right operand" do
            expect(node.result).to eql(result)
          end
        end
      end

      describe "#to_s" do
        let(:left_operand) { described_class.literal.new("2") }
        let(:right_operand) { described_class.literal.new("3") }

        it "converts operator to human-readable expression" do
          expect(node.to_s).to eql("2 AND 3")
        end
      end
    end

    describe "OR" do
      subject(:operator_class) { described_class.operators.find_by_token("OR") }
      subject(:node) { operator_class.new(left_operand, right_operand) }

      describe "#result" do
        context "with truthy operands" do
          let(:left_operand) { described_class.literal.new(true) }
          let(:right_operand) { described_class.literal.new(true) }
          let(:result) { true }

          it "should OR left operand and right operand" do
            expect(node.result).to eql(result)
          end
        end

        context "with falsey operands" do
          let(:left_operand) { described_class.literal.new(false) }
          let(:right_operand) { described_class.literal.new(false) }
          let(:result) { false }

          it "should OR left operand and right operand" do
            expect(node.result).to eql(result)
          end
        end
      end

      describe "#to_s" do
        let(:left_operand) { described_class.literal.new("2") }
        let(:right_operand) { described_class.literal.new("3") }

        it "converts operator to human-readable expression" do
          expect(node.to_s).to eql("2 OR 3")
        end
      end
    end

    describe "NOT" do
      subject(:operator_class) { described_class.operators.find_by_token("NOT") }
      subject(:node) { operator_class.new(operand) }

      describe "#result" do
        context "with truthy operand" do
          let(:operand) { described_class.literal.new(true) }
          let(:result) { false }

          it "should NOT the operand" do
            expect(node.result).to eql(result)
          end
        end

        context "with falsey operands" do
          let(:operand) { described_class.literal.new(false) }
          let(:result) { true }

          it "should NOT the operand" do
            expect(node.result).to eql(result)
          end
        end
      end

      describe "#to_s" do
        let(:operand) { described_class.literal.new("3") }

        it "converts operator to human-readable expression" do
          expect(node.to_s).to eql("NOT 3")
        end
      end
    end
  end
end
