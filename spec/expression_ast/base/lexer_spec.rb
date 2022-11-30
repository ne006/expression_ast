# frozen_string_literal: true

require "expression_ast/base/lexer"

RSpec.describe ExpressionAST::Base::Lexer do
  let(:expression) { "2 AND 2" }
  let(:grammar) do
    group = double("group").tap do |g|
      allow(g).to receive(:start_token).and_return("(")
      allow(g).to receive(:end_token).and_return(")")
    end

    operator = double("operator").tap do |o|
      allow(o).to receive(:token).and_return("AND")
    end

    double("grammar").tap do |g|
      allow(g).to receive(:group).and_return(group)
      allow(g).to receive(:operators).and_return([[operator]])
    end
  end
  subject(:lexer) { described_class.new(grammar) }

  describe "#grammar" do
    it "should return grammar" do
      expect(lexer.grammar).to eql(grammar)
    end
  end

  describe "#tokens" do
    subject(:result) { lexer.tokens(expression) }

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
