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
  haml :index
end

get '/lesson/:lesson' do |lesson|
  @code = ''

  prepare_lesson(lesson)
  haml :output
end

post '/lesson/:lesson' do |lesson|
  @code   = params['code']
  @output = ruby_code(@code, lesson)

  prepare_lesson(lesson)
  haml :output
end

def prepare_lesson(lesson)
  @path = "/lesson/#{lesson}"
  lesson_file  = "./lessons/lesson_#{lesson}.html"
  @lesson_text = File.open(File.expand_path(lesson_file)).readlines.join
end

def ruby_code(code, lesson = nil)
  lesson_code = lesson_include = ""
  if lesson
    lesson_file = "./lessons/lesson_#{lesson}.rb"
    lesson_code = File.open(File.expand_path(lesson_file)).readlines.join
    lesson_include = File.open(File.expand_path("./lesson_include.rb")).readlines.join
  end

  # STOLEN! from TryRuby
  # https://github.com/Sophrinix/TryRuby/blob/master/tryruby/lib/tryruby.rb
  stdout_id = $stdout.to_i
  $stdout = StringIO.new
  cmd = <<-EOF
  $SAFE = 3
  $stderr = StringIO.new
  #{code}
  #{lesson_include}
  #{lesson_code}
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
