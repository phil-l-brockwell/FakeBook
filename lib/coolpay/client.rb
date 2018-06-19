# frozen_string_literal: true

require 'json'
require 'rest_client'
require './lib/response/success.rb'
require './lib/response/error.rb'

module Coolpay
  class Client
    BASE_URL = 'https://coolpay.herokuapp.com/api/'
    DEFAULT_CURRENCY = :GBP
    HTTP_HEADERS = { 'content-type': 'application/json' }.freeze

    def initialize(args = {})
      @username = args[:username]
      @apikey = args[:apikey]
      @api_token = args[:api_token]
    end

    def authenticate
      return error('username and/or apikey not present!') unless @username && @apikey
      body = { username: @username, apikey: @apikey }
      api_request(:post, :login, body)
    rescue RestClient::NotFound
      error('username and/or apikey invalid!')
    end

    def add_recipient(recipient_name)
      return error('api_token not present! Ensure your credentials are correct and authenticated') unless @api_token
      return error('invalid recipient_name!') if recipient_name.empty?
      body = { recipient: { name: recipient_name } }
      api_request(:post, :recipients, body)
    end

    def get_recipients
      return error('api_token not present! Ensure your credentials are correct and authenticated') unless @api_token
      api_request(:get, :recipients, nil)
    end

    def add_payment(payment_amount, recipient_id)
      return error('api_token not present! Ensure your credentials are correct and authenticated') unless @api_token
      body = { payment: { amount: payment_amount, currency: DEFAULT_CURRENCY, recipient_id: recipient_id } }
      api_request(:post, :payments, body)
    rescue RestClient::InternalServerError
      error('recipient_id does not exist!')
    end

    def get_payments
      return error('api_token not present! Ensure your credentials are correct and authenticated') unless @api_token
      api_request(:get, :payments, nil)
    end

    private

    def api_request(http_verb, path, body)
      url = BASE_URL + path.to_s
      headers = request_headers.merge(params: body)
      response = RestClient::Request.execute(method: http_verb, url: url, headers: headers)
      response_hash = JSON.parse(response.body)
      Response::Success.new(response_hash)
    rescue RestClient::Unauthorized
      error('invalid api_token!')
    end

    def error(message)
      Response::Error.new(error_message: message)
    end

    def request_headers
      @api_token ? HTTP_HEADERS.merge('Authorization': "Bearer #{@api_token}") : HTTP_HEADERS
    end
  end
end
