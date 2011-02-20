$:.unshift File.expand_path File.dirname(__FILE__)
require 'rib'
run Sinatra::Application
