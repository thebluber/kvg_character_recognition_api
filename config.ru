require File.expand_path('../app.rb', __FILE__)

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
  end
end
use Rack::Static, :urls => ["/css", "/js"], :root => "public"
use Rack::Static, :urls => {'/' => 'index.html'}, root: 'public'

run API::Version1
