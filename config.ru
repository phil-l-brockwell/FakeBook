# frozen_string_literal: true

require_relative 'app'
require 'warden'
require 'dotenv'

Dotenv.load('./secrets.env')

use Rack::MethodOverride
use Rack::Session::Cookie, secret: ENV.fetch('RACK_SESSION_COOKIE_SECRET')

use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = self
  manager.serialize_from_session { |id| User.get(id) }
  manager.serialize_into_session(&:id)
end

run FakeBook
