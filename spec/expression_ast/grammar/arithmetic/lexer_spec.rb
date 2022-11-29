# frozen_string_literal: true

require "expression_ast/grammar/arithmetic"
require "expression_ast/grammar/arithmetic/lexer"

RSpec.describe ExpressionAST::Grammar::Arithmetic::Lexer do
  let(:grammar) { ExpressionAST::Grammar::Arithmetic }
  let(:expression) { "2 + 2" }
  subject(:lexer) { described_class.new(grammar) }

  describe "#grammar" do
    it "should return ExpressionAST::Grammar::Arithmetic" do
      expect(lexer.grammar).to eql(ExpressionAST::Grammar::Arithmetic)
    end
  end

  describe "#tokens" do
    let(:result) { lexer.tokens(expression) }

    context "when expression is normalized" do
      let(:expression) { "9 / 3 + 4 * ( 2 + 1 * ( 17 - 13 ) ) + 5 * 10" }
      let(:tokens) do
        ["9", "/", "3", "+", "4", "*", "(", "2", "+", "1", "*", "(", "17", "-", "13", ")", ")", "+", "5", "*", "10"]
      end

      it "should return token list" do
        expect(result).to eql(tokens)
      end
    end

    context "when expression is not normalized" do
      let(:expression) { "9/3 + 4*(2+1*(17-13))+5*10" }
      let(:tokens) do
        ["9", "/", "3", "+", "4", "*", "(", "2", "+", "1", "*", "(", "17", "-", "13", ")", ")", "+", "5", "*", "10"]
      end

      it "should return token list" do
        expect(result).to eql(tokens)
      end
    end
  end
end
