# frozen_string_literal: true

module UserActions
  USERNAME_LENGTH = 8
  PASSWORD_LENGTH = 6

  private

  def error(message)
    Response::Error.new(error_message: message)
  end

  def valid_password?
    @password.length > PASSWORD_LENGTH
  end

  def valid_username?
    @username.length > USERNAME_LENGTH
  end
end
