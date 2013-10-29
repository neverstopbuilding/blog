Encoding.default_internal = Encoding::UTF_8

require 'bundler/setup'
require 'rack/contrib/try_static'
require 'rack/contrib/not_found'
require 'rack/rewrite'

use Rack::Deflater

Bundler.require(:default)

# Testing these rules
use Rack::Rewrite do
  r301 /(.*)\/index\.html$/i, 'http://www.neverstopbuilding.com$1'
  r301 /.*/, 'http://www.neverstopbuilding.com$&', if: proc { |rack_env| rack_env['SERVER_NAME'] != 'www.neverstopbuilding.com' }
  r301 /category\/?$/i, 'http://www.neverstopbuilding.com/archive'
end

use Rack::TryStatic,
  urls: %w[/],
  root: 'build/deploy',
  try: ['index.html', '/index.html'],
  header_rules: [
    ['atom.xml', { 'Content-Type' => 'application/atom+xml' }],
    [['xml'], { 'Content-Type' => 'application/xml' }],
    [['html'],  { 'Content-Type' => 'text/html; charset=utf-8' }],
    [['css'],   { 'Content-Type' => 'text/css' }],
    [['js'],    { 'Content-Type' => 'text/javascript' }],
    [['png'],   { 'Content-Type' => 'image/png' }],
    ['/assets', { 'Cache-Control' => 'public, max-age=31536000' }],
  ]

run Rack::NotFound.new('build/deploy/404.html')
