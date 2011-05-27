# Because Unicorn is such a brilliant piece of software, it wraps older,
# non-Rack versions of Rails in a Rack handler. That way Unicorn
# itself can target Rack and not have to worry about monkey patching
# Rails' dispatcher.
#
# This means we can do the same, and even more.
#
# Starting Rackhub locally:
#
# Thin:
#   $ thin -R config.ru start
#
# Unicorn:
#   $ unicorn_rails -c config/unicorn.rb
#
# JRuby:
#   $ sudo env RAILS_ENV=fi jruby -S rackup -s mongrel -p 80

# Load our Rails app and Rack wrapper
require 'config/environment'
require 'unicorn/app/old_rails'
require 'unicorn/oob_gc'

module Rails
  module Rack
    # We're telling Unicorn we're not an old version of Rails, even
    # though we are. As such, if we're running in the foreground
    # Unicorn will want LogTailer. So we hand it a stub.
    class LogTailer
      def initialize(app)
        @app = app
      end
      def call(env)
        @app.call(env)
      end
    end

    if RAILS_ENV == 'development'
      # If you're not using Nginx or something else to serve static
      # assets locally, Unicorn will try to use a Rack middleware to
      # do it. Again: we're old Rails pretending to be new Rails, so we
      # lie slightly.
      require 'unicorn/app/old_rails/static'
      Static = Unicorn::App::OldRails::Static
    else
      # we never want to use static in non-development environments, since nginx
      # handles this for us.
      class Static
        def initialize(app)
          @app = app
        end
        def call(env)
          @app.call(env)
        end
      end
    end
  end
end

# Out-of-band GC, runs GC after every 10th request and after the response
# has been delivered.
use Unicorn::OobGC, interval=10

# Testing, testing.
map '/__rack__' do
  run proc { [ 200, { 'Content-Type' => 'text/plain' }, "Rails on Rack!" ] }
end

# Where the magic happens, so to speak.
map '/' do
  if RAILS_ENV != 'production'
    begin
      require 'rack/bug'
      use Rack::Bug, :password => nil
    rescue LoadError
    end

    use Rails::Rack::Static
  end

  run Unicorn::App::OldRails.new
end
GC.start
