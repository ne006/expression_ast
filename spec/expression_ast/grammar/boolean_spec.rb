# frozen_string_literal: true

require "expression_ast/grammar/boolean"

RSpec.describe ExpressionAST::Grammar::Boolean do
  subject(:grammar) { described_class }

  describe ".lexer" do
    it "should return Arithmetic::Lexer" do
      expect(grammar.lexer).to be(described_class::Lexer)
    end
  end

  describe ".literal" do
    it "should return Boolean::Node" do
      expect(grammar.literal).to be(described_class::Node)
    end
  end

  describe ".group" do
    it "should return Boolean::Group" do
      expect(grammar.group).to be(described_class::Group)
    end
  end

  describe ".operators" do
    it "should return Boolean operators grouped by their priority" do
      expect(grammar.operators).to eql(
        [
          [described_class::Operators::Conjunction],
          [described_class::Operators::Disjunction]
        ]
      )
    end
  end
end
