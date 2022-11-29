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
end
