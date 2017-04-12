class Lexer
  KEYWORDS = ['def', 'class', 'if', 'false', 'nil']
  REGEX = {
    identifier: /\A([a-z]\w*)/,
    constant: /\A([A-Z]\w*)/,
    number: /\A([0-9]+)/,
    string: /\A([^"]*)"/,
    operator: /\A(AND|OR|==|!=|<=|>=)/,
    line: /\A\n+/,
    whitespace: /\A /
  }

  attr_reader :code, :tokens

  def initialize(code)
    @code = code
    @tokens = []
  end

  def tokenize
    code.chomp!
    position = 0

    while position < code.size
      position = parse_tokens(position)
    end
  end

  private

  def parse_tokens(position)
    chunk = code[position..-1]

    if identifier = chunk[REGEX[:identifier], 1]
      position + token_identifier(identifier)
    elsif constant = chunk[REGEX[:constant], 1]
      position + token_constant(constant)
    elsif number = chunk[REGEX[:number], 1]
      position + token_number(number)
    elsif string = chunk[REGEX[:string], 1]
      position + token_string(string)
    elsif operator = chunk[REGEX[:operator], 1]
      position + token_operator(operator)
    elsif chunk.match(REGEX[:line])
      token_new_line
      position += 1
    elsif chunk.match(REGEX[:whitespace])
      position += 1
    else
      value = chunk[0, 1]
      tokens << [value, value]
      position + 1
    end
  end

  def token_identifier(identifier)
    if KEYWORDS.include?(identifier)
      tokens << [identifier.upcase.to_sym, identifier]
    else
      tokens << [:IDENTIFIER, identifier]
    end
    identifier.size
  end

  def token_constant(constant)
    tokens << [:CONSTANT, constant]
    constant.size
  end

  def token_number(number)
    tokens << [:NUMBER, number]
    number.size
  end

  def token_string(string)
    tokens << [:STRING, string]
    string.size + 2
  end

  def token_operator(operator)
    tokens << [operator, operator]
    operator.size
  end

  def token_new_line
    tokens << [:NEWLINE, "\n"]
  end
end

code = """if a == 10 {
  a = 25
}"""

lexer = Lexer.new(code)
lexer.tokenize
print(lexer.tokens)
