# frozen_string_literal: true

require 'active_support'
require 'bcrypt'
require 'sequel'
require 'sinatra/base'
require 'sinatra/decorator'
require './decorators/user'

class User < Sequel::Model
  include BCrypt
  include Sinatra::Decorator::Decoratable

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    self.password_hash = @password = Password.create(new_password)
  end

  def authenticate(attempted_password)
    password == attempted_password
  end

  def coolpay_authenticated?
    !coolpay_api_token.nil?
  end
end
