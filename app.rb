# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'

require_relative 'config/warden'
require_relative 'config/database'

require_relative 'lib/coolpay/client'

require_relative 'routes/session'
require_relative 'routes/user'
require_relative 'routes/money'

class FakeBook < Sinatra::Base
  register Sinatra::Flash
  register Sinatra::SessionRoutes
  register Sinatra::UserRoutes
  register Sinatra::MoneyRoutes

  DEFAULT_PAYMENTS_PROVIDER = Coolpay

  get '/' do
    warden.authenticate!
    erb :index
  end

  private

  def warden
    env['warden']
  end

  def current_user
    @current_user ||= User.find(id: warden.user)
  end

  def payments_provider_name_string
    @payments_provider_name.to_s.downcase
  end

  def set_payment_provider
    @payments_provider_name = DEFAULT_PAYMENTS_PROVIDER
    @payments_provider = @payments_provider_name::Client.new(
      api_token: current_user.public_send("#{payments_provider_name_string}_api_token"),
      username: current_user.public_send("#{payments_provider_name_string}_username"),
      apikey: current_user.public_send("#{payments_provider_name_string}_api_key")
    )
  end
end
