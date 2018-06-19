# frozen_string_literal: true

require_relative 'user_actions'

class UpdateUser
  include UserActions

  def initialize(params)
    @user = User.find(id: params[:id])
    @username = params[:username]
    @password = params[:password]
    @coolpay_username = params[:coolpay_username]
    @coolpay_api_key = params[:coolpay_api_key]
    @coolpay_api_token = params[:coolpay_api_token]
  end

  def perform
    return error 'User not found!' unless @user

    if @username
      if valid_username?
        @user.username = @username
      else
        return error "Invalid Username! Must be atleast #{USERNAME_LENGTH} characters"
      end
    end

    if @password
      if valid_password?
        @user.password = @password
      else
        return error "Invalid Password! Must be atleast #{PASSWORD_LENGTH} characters"
      end
    end

    @user.coolpay_username = @coolpay_username if @coolpay_username
    @user.coolpay_api_key = @coolpay_api_key if @coolpay_api_key
    @user.coolpay_api_token = @coolpay_api_token if @coolpay_api_token

    @user.save

    Response::Success.new("User id: #{@user.id} successfully updated!")
  end
end
