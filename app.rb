# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'

require_relative 'config/database'

class FakeBook < Sinatra::Base
  register Sinatra::Flash

  get '/' do
    'Hello World'
  end
end
