# frozen_string_literal: true

require "expression_ast/parser"
require "expression_ast/grammar/arithmetic"

RSpec.describe ExpressionAST::Parser do
  subject(:parser) { described_class.new(grammar) }

  describe "#build_expression_ast" do
    let(:tree) { parser.build_expression_ast(expression) }

    context "with Arithmetic grammar" do
      let(:grammar) { ExpressionAST::Grammar::Arithmetic }

      context "with literal expression" do
        let(:expression) { "9560" }
        let(:expected_tree) do
          grammar::Node.new(9560)
        end

        it "builds AST" do
          expect(tree).to be == expected_tree
        end

        it "builds AST which returns correct result" do
          expect(tree.result).to eql(9560.0)
        end
      end

      context "with group expression" do
        let(:expression) { "(5)" }
        let(:expected_tree) do
          grammar::Group.new(grammar::Node.new(5))
        end

        it "builds AST" do
          expect(tree).to be == expected_tree
        end

        it "builds AST which returns correct result" do
          expect(tree.result).to eql(5.0)
        end
      end

      context "with binary operator expression" do
        let(:expression) { "2 + 2" }
        let(:expected_tree) do
          grammar::Operators::Addition.new(grammar::Node.new(2), grammar::Node.new(2))
        end

        it "builds AST" do
          expect(tree).to be == expected_tree
        end

        it "builds AST which returns correct result" do
          expect(tree.result).to eql(4.0)
        end
      end

      context "with simple expression" do
        let(:expression) { "2 + 2 * (5 - 3)" }
        let(:expected_tree) do
          grammar::Operators::Addition.new(
            grammar::Node.new(2),
            grammar::Operators::Multiplication.new(
              grammar::Node.new(2),
              grammar::Group.new(
                grammar::Operators::Substraction.new(grammar::Node.new(5), grammar::Node.new(3))
              )
            )
          )
        end

        it "builds AST" do
          expect(tree).to be == expected_tree
        end

        it "builds AST which returns correct result" do
          expect(tree.result).to eql(6.0)
        end
      end

      context "with complex expression" do
        let(:expression) { "9/3 + 4*(2+1*(7 - 3 )) + 5 * 10" }
        let(:expected_tree) do
          grammar::Operators::Addition.new(
            grammar::Operators::Division.new(grammar::Node.new(9), grammar::Node.new(3)),
            grammar::Operators::Addition.new(
              grammar::Operators::Multiplication.new(
                grammar::Node.new(4),
                grammar::Group.new(
                  grammar::Operators::Addition.new(
                    grammar::Node.new(2),
                    grammar::Operators::Multiplication.new(
                      grammar::Node.new(1),
                      grammar::Group.new(
                        grammar::Operators::Substraction.new(grammar::Node.new(7), grammar::Node.new(3))
                      )
                    )
                  )
                )
              ),
              grammar::Operators::Multiplication.new(grammar::Node.new(5), grammar::Node.new(10))
            )
          )
        end

        it "builds AST" do
          expect(tree).to be == expected_tree
        end

        it "builds AST which returns correct result" do
          expect(tree.result).to eql(77.0)
        end
      end
    end
  end
end
