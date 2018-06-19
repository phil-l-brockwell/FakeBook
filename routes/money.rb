# frozen_string_literal: true

require 'sinatra/base'

module Sinatra
  module MoneyRoutes
    def self.registered(app)
      app.get '/money' do
        warden.authenticate!
        set_payment_provider
        erb :'/money/index'
      end

      app.get '/money/payments' do
        warden.authenticate!
        set_payment_provider
        api_response = @payments_provider.get_payments
        if api_response.success?
          @payments = api_response.details['payments']
        else
          flash.now[:error] = api_response.error_message
        end
        erb :'/money/payments'
      end

      app.post '/money/payments' do
        warden.authenticate!
        set_payment_provider
        api_response = @payments_provider.add_payment(params[:amount], params[:recipient_id])
        if api_response.success?
          flash.next[:alert] = 'Payment successfully added'
        else
          flash.next[:error] = api_response.error_message
        end

        redirect to '/money/payments'
      end

      app.get '/money/settings' do
        warden.authenticate!
        set_payment_provider
        @username = current_user.public_send("#{payments_provider_name_string}_username")
        @api_key = current_user.public_send("#{payments_provider_name_string}_api_key")
        erb :'/money/settings'
      end

      app.get '/money/recipients' do
        warden.authenticate!
        set_payment_provider
        api_response = @payments_provider.get_recipients
        if api_response.success?
          @recipients = api_response.details['recipients']
        else
          flash.now[:error] = api_response.error_message
        end
        erb :'/money/recipients'
      end

      app.post '/money/recipients' do
        warden.authenticate!
        set_payment_provider
        api_response = @payments_provider.add_recipient(params[:recipient_name])
        if api_response.success?
          flash.next[:alert] = "Recipient: #{params[:recipient_name]} successfully added"
        else
          flash.next[:error] = api_response.error_message
        end

        redirect to '/money/recipients'
      end

      app.post '/money/authenticate' do
        warden.authenticate!
        set_payment_provider
        api_response = @payments_provider.authenticate

        unless api_response.success?
          flash.next[:error] = api_response.error_message
          redirect to '/money/settings'
        end

        api_token = api_response.details['token']
        params = Hash["#{payments_provider_name_string}_api_token".to_sym, api_token, :id, current_user.id]
        api_response = UpdateUser.new(params).perform

        if api_response.success?
          flash.next[:alert] = 'Successfully authenticated!'
        else
          flash.next[:error] = api_response.error_message
        end

        redirect to '/money/settings'
      end
    end
  end

  register MoneyRoutes
end
