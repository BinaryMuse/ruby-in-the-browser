RubyInBrowser.check_answers(
  lambda { |x| "triple_string(\"#{x}\")" },
  lambda { |x| triple_string(x) },
  [
    ["something", "somethingsomethingsomething"],
    ["Abe", "AbeAbeAbe"],
    ["123", "123123123"],
    ["", ""]
  ]
)