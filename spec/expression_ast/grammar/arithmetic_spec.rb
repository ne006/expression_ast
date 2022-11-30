# frozen_string_literal: true

require "expression_ast/grammar/arithmetic"

RSpec.describe ExpressionAST::Grammar::Arithmetic do
  describe ".lexer" do
    it "should return Base::Lexer" do
      expect(described_class.lexer).to be(ExpressionAST::Base::Lexer)
    end
  end

  describe ".literal" do
    subject(:node) { described_class.literal.new(value) }

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

  describe ".group" do
    subject(:node) { described_class.group.new(value) }

    describe "#to_s" do
      context "with simple literal value" do
        let(:value) { described_class.literal.new("5") }
        let(:expression) { "( 5.0 )" }

        it "converts group to human-readable expression" do
          expect(node.to_s).to eql(expression)
        end
      end

      context "with group-nested literal value" do
        let(:value) { described_class.group.new(described_class.literal.new("5")) }
        let(:expression) { "( ( 5.0 ) )" }

        it "converts group to human-readable expression" do
          expect(node.to_s).to eql(expression)
        end
      end
    end
  end

  describe ".operators" do
    it "should return Arithmetic operators grouped by their priority" do
      expect(described_class.operators.map { _1.map(&:token) }).to eql(
        [%w[^], %w[* /], %w[+ -]]
      )
    end

    describe "+" do
      subject(:operator_class) { described_class.operators.find_by_token("+") }
      subject(:node) { operator_class.new(left_operand, right_operand) }

      describe "#result" do
        context "with integer operands" do
          let(:left_operand) { described_class.literal.new("2") }
          let(:right_operand) { described_class.literal.new("3") }
          let(:result) { 5.0 }

          it "should sum left operand with right operand" do
            expect(node.result).to eql(result)
          end
        end

        context "with float operands" do
          let(:left_operand) { described_class.literal.new("2.5") }
          let(:right_operand) { described_class.literal.new("3.1") }
          let(:result) { 5.6 }

          it "should sum left operand with right operand" do
            expect(node.result).to eql(result)
          end
        end
      end

      describe "#to_s" do
        let(:left_operand) { described_class.literal.new("2") }
        let(:right_operand) { described_class.literal.new("3") }

        it "converts operator to human-readable expression" do
          expect(node.to_s).to eql("2.0 + 3.0")
        end
      end
    end

    describe "-" do
      subject(:operator_class) { described_class.operators.find_by_token("-") }
      subject(:node) { operator_class.new(left_operand, right_operand) }

      describe "#result" do
        context "with integer operands" do
          let(:left_operand) { described_class.literal.new("2") }
          let(:right_operand) { described_class.literal.new("3") }
          let(:result) { -1.0 }

          it "should substract right operand from left operand" do
            expect(node.result).to eql(result)
          end
        end

        context "with float operands" do
          let(:left_operand) { described_class.literal.new("2.5") }
          let(:right_operand) { described_class.literal.new("0.5") }
          let(:result) { 2.0 }

          it "should substract right operand from left operand" do
            expect(node.result).to eql(result)
          end
        end

        describe "#to_s" do
          let(:left_operand) { described_class.literal.new("2") }
          let(:right_operand) { described_class.literal.new("3") }

          it "converts operator to human-readable expression" do
            expect(node.to_s).to eql("2.0 - 3.0")
          end
        end
      end
    end

    describe "*" do
      subject(:operator_class) { described_class.operators.find_by_token("*") }
      subject(:node) { operator_class.new(left_operand, right_operand) }

      describe "#result" do
        context "with integer operands" do
          let(:left_operand) { described_class.literal.new("2") }
          let(:right_operand) { described_class.literal.new("3") }
          let(:result) { 6.0 }

          it "should multiply left operand by right operand" do
            expect(node.result).to eql(result)
          end
        end

        context "with float operands" do
          let(:left_operand) { described_class.literal.new("2.5") }
          let(:right_operand) { described_class.literal.new("0.5") }
          let(:result) { 1.25 }

          it "should multiply left operand by right operand" do
            expect(node.result).to eql(result)
          end
        end
      end

      describe "#to_s" do
        let(:left_operand) { described_class.literal.new("2") }
        let(:right_operand) { described_class.literal.new("3") }

        it "converts operator to human-readable expression" do
          expect(node.to_s).to eql("2.0 * 3.0")
        end
      end
    end

    describe "/" do
      subject(:operator_class) { described_class.operators.find_by_token("/") }
      subject(:node) { operator_class.new(left_operand, right_operand) }

      describe "#result" do
        context "with integer operands" do
          let(:left_operand) { described_class.literal.new("6") }
          let(:right_operand) { described_class.literal.new("3") }
          let(:result) { 2.0 }

          it "should div left operand by right operand" do
            expect(node.result).to eql(result)
          end
        end

        context "with float operands" do
          let(:left_operand) { described_class.literal.new("2.5") }
          let(:right_operand) { described_class.literal.new("0.5") }
          let(:result) { 5.0 }

          it "should div left operand by right operand" do
            expect(node.result).to eql(result)
          end
        end
      end

      describe "#to_s" do
        let(:left_operand) { described_class.literal.new("2") }
        let(:right_operand) { described_class.literal.new("3") }

        it "converts operator to human-readable expression" do
          expect(node.to_s).to eql("2.0 / 3.0")
        end
      end
    end

    describe "^" do
      subject(:operator_class) { described_class.operators.find_by_token("^") }
      subject(:node) { operator_class.new(left_operand, right_operand) }

      describe "#result" do
        context "with integer operands" do
          let(:left_operand) { described_class.literal.new("2") }
          let(:right_operand) { described_class.literal.new("3") }
          let(:result) { 8.0 }

          it "should substract right operand from left operand" do
            expect(node.result).to eql(result)
          end
        end

        context "with float operands" do
          let(:left_operand) { described_class.literal.new("4") }
          let(:right_operand) { described_class.literal.new("0.5") }
          let(:result) { 2.0 }

          it "should substract right operand from left operand" do
            expect(node.result).to eql(result)
          end
        end

        describe "#to_s" do
          let(:left_operand) { described_class.literal.new("2") }
          let(:right_operand) { described_class.literal.new("3") }

          it "converts operator to human-readable expression" do
            expect(node.to_s).to eql("2.0 ^ 3.0")
          end
        end
      end
    end
  end
end
