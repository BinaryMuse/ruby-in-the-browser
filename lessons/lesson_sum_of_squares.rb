RubyInBrowser.check_answers(
  lambda { |*args| "sum_of_squares(#{args.join ", "})" },
  lambda { |*args| sum_of_squares(*args) },
  [
    [0, 0],
    [2, 4],
    [[2, 3], 13],
    [[2, 3, 4], 29]
  ]
)