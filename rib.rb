require 'sinatra'
require 'haml'
require 'stringio'

class Output
  attr_reader :type, :content, :message

  def initialize(type, content, message = nil)
    @type    = type
    @content = content
    @message = message
  end
end

get '/' do
  @code = ''
  haml :index
end

post '/' do
  @code = params['code']
  @output = ruby_code(@code)
  haml :output
end

def ruby_code(code)
  # STOLEN! from TryRuby
  # https://github.com/Sophrinix/TryRuby/blob/master/tryruby/lib/tryruby.rb
  stdout_id = $stdout.to_i
  $stdout = StringIO.new
  cmd = <<-EOF
  $SAFE = 3
  $stdout = StringIO.new
  $stderr = StringIO.new
  #{code}
  EOF

  begin
    result = Thread.new { eval cmd, TOPLEVEL_BINDING }.value
  rescue SecurityError => e
    return Output.new(:illegal, get_stdout, e.to_s)
  rescue Exception => e
    return Output.new(:exception, get_stdout, e.to_s)
  ensure
    output = get_stdout
    $stdout = IO.new(stdout_id)
  end

  return Output.new(:standard, output)
end

def get_stdout
  $stdout.rewind
  $stdout.read
end
