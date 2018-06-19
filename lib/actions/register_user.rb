# frozen_string_literal: true

require_relative 'user_actions'

class RegisterUser
  include UserActions

  def initialize(args)
    @username = args[:username]
    @password = args[:password]
  end

  def perform
    user = User.new

    if valid_username?
      user.username = @username
    else
      return error "Invalid Username! Must be atleast #{USERNAME_LENGTH} characters"
    end

    if valid_password?
      user.password = @password
    else
      return error "Invalid Password! Must be atleast #{PASSWORD_LENGTH} characters"
    end

    user.save

    Response::Success.new(user: user)
  end
end
