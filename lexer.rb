class Lexer
  KEYWORDS = ['def', 'class', 'if', 'false', 'nil']

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

    if identifier = chunk[/\A([a-z]\w*)/, 1]
      position + token_identifier(identifier)
    else
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
end

code = """
if a == 10 {
  a = 25
}
"""

lexer = Lexer.new(code)
lexer.tokenize
print(lexer.tokens)
