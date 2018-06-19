# frozen_string_literal: true

require 'warden'

Warden::Strategies.add :password do
  def valid?
    params['username'] || params['password']
  end

  def authenticate!
    user = User.find username: params['username']
    user&.authenticate(params['password']) ? success!(user) : fail!
  end
end
