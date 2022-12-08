# ExpressionAST

A gem to parse expressions defined by some grammar. Prepackaged with arithmetic and boolean grammars.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add expression_ast

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install expression_ast

## Usage

### Parser usage with a grammar

Create a `ExpressionAST::Parser` with your grammar and call `#build_expression_ast` with your expression as an argument to get your expression tree:

```ruby
parser = ExpressionAST::Parser.new(ExpressionAST::Grammar::Boolean)
tree = parser.build_expression_ast('true AND true')
```

or pass a `Hash` tree to build it:

```ruby
parser = ExpressionAST::Parser.new(ExpressionAST::Grammar::Boolean)
tree = parser.build_expression_ast({
  'type' => 'binary_operator',
  'token' => 'AND',
  'left_operand' => { 'type' => 'node', 'value' => 'true' },
  'right_operand' => { 'type' => 'node', 'value' => 'true' }
})
```

Call `#result` on the tree to evaluate the expression:

```ruby
tree.result
# => true
```

Call `#to_h` to serialize it:

```ruby
tree.to_h
# => { type: :binary_operator, token: 'AND', left_operand: { type: :node, value: 'true'}, right_operand: { type: :node, value: 'true'} }
```

### Grammar definition

Inherit from `ExpressionAST::Base::Grammar` and define grammar with DSL methods:

```ruby
require "expression_ast/base/grammar"

class Arithmetic < ::ExpressionAST::Base::Grammar
  literal do
    parse_value { value.to_f }
  end

  operators do
    grouped do
      binary_operator do
        token "^"
        result { left_operand.result**right_operand.result }
      end
    end
    grouped do
      binary_operator do
        token "*"
        result { left_operand.result * right_operand.result }
      end
      binary_operator do
        token "/"
        result { left_operand.result / right_operand.result }
      end
    end
    grouped do
      binary_operator do
        token "+"
        result { left_operand.result + right_operand.result }
      end
      binary_operator do
        token "-"
        result { left_operand.result - right_operand.result }
      end
    end
  end
end
```

#### Lexer

By default, uses `ExpressionAST::Base::Lexer`.

Call `lexer CustomLexer` on your grammar class to set a custom one.

`CustomLexer#initialize` should receive grammar.

`CustomLexer#tokens` accepts the expression to parse as an argument and should return a list of tokens.

#### Literal

By default, uses `ExpressionAST::Base::Node`.

Call `literal do ... <your literal definition> ... end` on your grammar class to set a custom one:

```ruby
literal do
  parse_value { value.to_f }
end
```

Inside `literal` you can set:
- `parse_value` proc to parse literal value
- `result` proc to define result calculation of the literal
- `stringify` proc to define human-readable representation of the literal

Methods above provide access to node's `value`.

Yout can also pass a `ExpressionAST::Base::Node`-based class as an argument instead.

#### Group

By default, uses `ExpressionAST::Base::Group` with `(` and `)` border tokens.

Call `group do ... <your group definition> ... end` on your grammar class to set a custom one:

```ruby
group do
  start_token '('
  end_token ')'
end
```

Inside `group` you can set:
- `start_token` to set group start token
- `end_token` to set group start token
- `stringify` proc to define human-readable representation of the group 

Methods above provide access to node's `value`.

Yout can also pass a `ExpressionAST::Base::Group`-based class as an argument instead.

#### Operators

Define your grammar's operators, grouping them by their priority of evaluation.

Call `operators do ... <your grouped calls> ... end` on your grammar class to set them.

Call `grouped do ... <your unary_operator/binary_operator calls> ... end` inside block provided to `operators` call to define operator groups in descensing order of their priority.

Call `unary_operator do ... <your operator definition> ... end` or `binary_operator do ... <your operator definition> ... end` inside block provided to `grouped` call to define unary or binary operators accordingly.

```ruby
operators do # rubocop:disable Metrics/BlockLength
  grouped do
    binary_operator do
      token "+"
      result { left_operand.result + right_operand.result }
    end
    binary_operator do
      token "-"
      result { left_operand.result - right_operand.result }
    end
  end
end
```

Inside `unary_operator` you can set:
- `token` to set your operator's token
- `result` proc to define operator result calculation based on its `operand`
- `stringify` proc to define human-readable representation of the operator 

Inside `binary_operator` you can set:
- `token` to set your operator's token
- `result` proc to define operator result calculation based on its `left_operand` and `right_operand`
- `stringify` proc to define human-readable representation of the operator

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ne006/expression_ast. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ne006/expression_ast/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ExpressionAST project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/expression_ast/blob/master/CODE_OF_CONDUCT.md).
