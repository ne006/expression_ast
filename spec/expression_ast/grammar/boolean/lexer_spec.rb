# frozen_string_literal: true

require "expression_ast/grammar/boolean"
require "expression_ast/grammar/boolean/lexer"

RSpec.describe ExpressionAST::Grammar::Boolean::Lexer do
  let(:grammar) { ExpressionAST::Grammar::Boolean }
  let(:expression) { "2 AND 2" }
  subject(:lexer) { described_class.new(grammar) }

  describe "#grammar" do
    it "should return ExpressionAST::Grammar::Boolean" do
      expect(lexer.grammar).to eql(ExpressionAST::Grammar::Boolean)
    end
  end

  describe "#tokens" do
    let(:result) { lexer.tokens(expression) }

    context "when expression is normalized" do
      let(:expression) { "( a AND b ) OR c AND d" }
      let(:tokens) do
        ["(", "a", "AND", "b", ")", "OR", "c", "AND", "d"]
      end

      it "should return token list" do
        expect(result).to eql(tokens)
      end
    end

    context "when expression is not normalized" do
      let(:expression) { "(a AND b) OR c AND d" }
      let(:tokens) do
        ["(", "a", "AND", "b", ")", "OR", "c", "AND", "d"]
      end

      it "should return token list" do
        expect(result).to eql(tokens)
      end
    end
  end
end
