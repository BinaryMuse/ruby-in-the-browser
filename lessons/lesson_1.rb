PASS_STRING = "<span style='color: green;'>PASSED!</span>"
FAIL_STRING = "<span style='color: red;'>FAILED!</span>"

[
  ["something", "somethingsomethingsomething"],
  ["Abe", "AbeAbeAbe"],
  ["123", "123123123"],
  ["", ""]
].each do |pair|
  result = triple_string(pair[0])
  puts "triple_string(\"#{pair[0]}\")"
  puts "=> #{result.inspect}"
  puts result == pair[1] ? PASS_STRING : FAIL_STRING
end