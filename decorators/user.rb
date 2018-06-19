# frozen_string_literal: true

class UserDecorator < Sinatra::Decorator::Base
  def coolpay_status
    return :Authenticated if object.coolpay_authenticated?
    :'Not Authenticated'
  end
end
