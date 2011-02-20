PASS_STRING = "<span class='pass_string'>PASSED!</span>"
FAIL_STRING = "<span class='fail_string'>FAILED!</span>"

class RubyInBrowser
  # Checks an answer sheet against results produced by the user's code.
  #
  # line_lambda: block to execute to get the current "execute line",
  #   e.g., a string representation of the code we're calling to check the answer
  # result_lambda: block to execute to get the result to check
  # answer_sheet: an array of two-element arrays; element 1 is the correct
  #   result given element 0 (splatted) as input
  def self.check_answers(line_lambda, result_lambda, answer_sheet)
    answer_sheet.each do |pair|
      check_answer(line_lambda.call(*pair[0]), result_lambda.call(*pair[0]), pair[1])
    end
  end

  def self.check_answer(line, result, expected)
    puts line
    puts "=> #{result.inspect}"
    puts result == expected ? PASS_STRING : FAIL_STRING
  end
end
