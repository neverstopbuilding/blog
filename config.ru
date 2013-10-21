Encoding.default_internal = Encoding::UTF_8

require 'bundler/setup'
Bundler.require(:default)

run Rack::Jekyll.new(:destination => 'build/deploy')
