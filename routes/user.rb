# frozen_string_literal: true

require 'sinatra/base'

require './lib/actions/register_user'
require './lib/actions/update_user'

module Sinatra
  module UserRoutes
    def self.registered(app)
      app.get '/users/new' do
        if current_user
          flash.next[:alert] = 'Account is already registered!'
          redirect back
        end

        erb :'/users/new'
      end

      app.put '/users/:id' do
        response = UpdateUser.new(params).perform
        if response.success?
          flash.next[:alert] = 'User successfully updated'
        else
          flash.next[:error] = response.error_message
        end
        redirect back
      end

      app.post '/users' do
        response = RegisterUser.new(params).perform
        if response.success?
          warden.set_user(response.details[:user])
          flash.next[:alert] = 'User successfully registered'
          redirect to '/'
        else
          flash.next[:error] = response.error_message
          erb :'/users/new'
        end
      end
    end
  end

  register UserRoutes
end
