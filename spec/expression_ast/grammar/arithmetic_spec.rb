# frozen_string_literal: true

require "expression_ast/grammar/arithmetic"

RSpec.describe ExpressionAST::Grammar::Arithmetic do
  subject(:grammar) { described_class }

  describe ".lexer" do
    it "should return Arithmetic::Lexer" do
      expect(grammar.lexer).to be(described_class::Lexer)
    end
  end

  describe ".literal" do
    it "should return Arithmetic::Node" do
      expect(grammar.literal).to be(described_class::Node)
    end
  end

  describe ".group" do
    it "should return Arithmetic::Group" do
      expect(grammar.group).to be(described_class::Group)
    end
  end

  describe ".operators" do
    it "should return Arithmetic operators grouped by their priority" do
      expect(grammar.operators).to eql(
        [
          [described_class::Operators::Power],
          [described_class::Operators::Multiplication, described_class::Operators::Division],
          [described_class::Operators::Addition, described_class::Operators::Substraction]
        ]
      )
    end
  end
end
