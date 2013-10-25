Encoding.default_internal = Encoding::UTF_8

require 'bundler/setup'
require 'rack/contrib/try_static'
require 'rack/contrib/not_found'
require 'rack/rewrite'

use Rack::Deflater

Bundler.require(:default)

# Testing these rules
use Rack::Rewrite do
  r301 %r{.*}, 'http://www.neverstopbuilding.com$&', :if => Proc.new { |rack_env| rack_env['SERVER_NAME'] != 'www.neverstopbuilding.com' }
  r301 %{^(.*)\/index\.html$}, 'http://www.neverstopbuilding.com$1'
end

use Rack::TryStatic,
  urls: %w[/],
  root: "build/deploy",
  try: ['index.html', '/index.html'],
  header_rules: [
    [%r{atom\.xml\z}, {'Content-Type' => 'application/atom+xml'}],
    [["xml"], {'Content-Type' => 'application/xml'}],
    [["html"],  {'Content-Type' => 'text/html; charset=utf-8'}],
    [["css"],   {'Content-Type' => 'text/css'}],
    [["js"],    {'Content-Type' => 'text/javascript'}],
    [["png"],   {'Content-Type' => 'image/png'}],
    ["/assets", {'Cache-Control' => 'public, max-age=31536000'}],
  ]

run Rack::NotFound.new('build/deploy/404.html')
