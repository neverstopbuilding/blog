Encoding.default_internal = Encoding::UTF_8

require 'bundler/setup'
require 'rack/contrib/try_static'
require 'rack/contrib/not_found'

use Rack::Deflater

Bundler.require(:default)

use Rack::TryStatic,
  urls: %w[/],
  root: "build/deploy",
  try: ['index.html', '/index.html'],
  header_rules: [
    [["html"],  {'Content-Type' => 'text/html; charset=utf-8'}],
    [["css"],   {'Content-Type' => 'text/css'}],
    [["js"],    {'Content-Type' => 'text/javascript'}],
    [["png"],   {'Content-Type' => 'image/png'}],
    ["/assets", {'Cache-Control' => 'public, max-age=31536000'}],
  ]

run Rack::NotFound.new('build/deploy/404.html')
