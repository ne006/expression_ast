# frozen_string_literal: true

require "expression_ast/base/grammar"

RSpec.describe ExpressionAST::Base::Grammar do
  describe ".lexer" do
    context "with specified lexer" do
      subject(:test_class) do
        l = lexer
        Class.new(described_class) do
          lexer l
        end
      end
      let(:lexer) { double("lexer") }

      it "should return specified lexer" do
        expect(test_class.lexer).to eql(lexer)
      end
    end

    context "without specified lexer" do
      subject(:test_class) { Class.new(described_class) }
      let(:lexer) { ExpressionAST::Base::Lexer }

      it "should return default lexer" do
        expect(test_class.lexer).to eql(lexer)
      end
    end
  end

  describe ".literal" do
    context "with definition block" do
      subject(:test_class) do
        Class.new(described_class, &def_proc)
      end
      let(:def_proc) do
        proc { literal { parse_value { |v| "[#{v}]" } } }
      end

      it "should return a subclass of Base::Node" do
        expect(test_class.literal.ancestors).to include(ExpressionAST::Base::Node)
      end

      it "should execute definition block" do
        expect(Class).to receive(:new) do |_base_class, &def_block|
          expect(def_block).to eql(def_proc)
        end

        test_class
      end

      context "with specified class" do
        let(:literal_class) { double("node") }
        let(:def_proc) do
          l = literal_class
          proc { literal l }
        end

        it "saves specified class as literal" do
          expect(test_class.literal).to eql(literal_class)
        end
      end
    end

    context "without definition block" do
      subject(:test_class) { Class.new(described_class) }

      it "should return a subclass of Base::Node" do
        expect(test_class.literal.ancestors).to include(ExpressionAST::Base::Node)
      end
    end
  end

  describe ".group" do
    context "with definition block" do
      subject(:test_class) do
        Class.new(described_class, &def_proc)
      end
      let(:def_proc) do
        proc do
          group do
            start_token "["
            end_token "]"
          end
        end
      end

      it "should return a subclass of Base::Node" do
        expect(test_class.group.ancestors).to include(ExpressionAST::Base::Group)
      end

      it "should execute definition block" do
        expect(Class).to receive(:new) do |_base_class, &def_block|
          expect(def_block).to eql(def_proc)
        end

        test_class
      end
    end

    context "without definition block" do
      subject(:test_class) { Class.new(described_class) }

      it "should return a subclass of Base::Node" do
        expect(test_class.group.ancestors).to include(ExpressionAST::Base::Group)
      end
    end
  end

  describe ".operators" do
    context "grouped by priority" do
      context "with binary operator" do
        let(:test_class) do
          p = def_proc
          Class.new(described_class) do
            operators { grouped { binary_operator(&p) } }
          end
        end
        let(:def_proc) do
          proc do
            token "+"
            result { |a, b| a + b }
          end
        end

        it "should return a subclass of Base::BinaryOperator" do
          expect(test_class.operators.first.first.ancestors).to include(ExpressionAST::Base::BinaryOperator)
        end

        it "should execute definition block" do
          allow(Class).to receive(:new).with(described_class).and_call_original
          expect(Class).to receive(:new).with(ExpressionAST::Base::BinaryOperator) do |_base_class, &def_block|
            expect(def_block).to eql(def_proc)
          end

          test_class
        end
      end

      context "with unary operator" do
        let(:test_class) do
          p = def_proc
          Class.new(described_class) do
            operators { grouped { unary_operator(&p) } }
          end
        end
        let(:def_proc) do
          proc do
            token "not"
            result(&:!)
          end
        end

        it "should return a subclass of Base::UnaryOperator" do
          expect(test_class.operators.first.first.ancestors).to include(ExpressionAST::Base::UnaryOperator)
        end

        it "should execute definition block" do
          allow(Class).to receive(:new).with(described_class).and_call_original
          expect(Class).to receive(:new).with(ExpressionAST::Base::UnaryOperator) do |_base_class, &def_block|
            expect(def_block).to eql(def_proc)
          end

          test_class
        end
      end

      context "with several operators" do
        let(:test_class) do
          Class.new(described_class) do
            operators do
              grouped do
                unary_operator { token "a" }
                binary_operator { token "b" }
              end
              grouped do
                binary_operator { token "c" }
              end
            end
          end
        end
        let(:ordered_tokens) { [%w[a b], %w[c]] }

        it "should return list of operator groups" do
          expect(test_class.operators.map { _1.map(&:token) }).to eql(ordered_tokens)
        end
      end

      context "without operators" do
        let(:test_class) { Class.new(described_class) }

        it "should return empty list without groups" do
          expect(test_class.operators).to be_empty
        end
      end
    end

    describe "#find_by_token" do
      let(:test_class) do
        Class.new(described_class) do
          operators do
            grouped do
              unary_operator { token "a" }
              binary_operator { token "b" }
            end
            grouped do
              binary_operator { token "c" }
            end
          end
        end
      end

      it "should return first operator with mathcing token" do
        expect(test_class.operators.find_by_token("c"))
          .to have_attributes(
            token: "c",
            ancestors: include(ExpressionAST::Base::BinaryOperator)
          )
      end
    end
  end
end
