# frozen_string_literal: true

require 'sinatra/base'

module Sinatra
  module SessionRoutes
    def self.registered(app)
      app.get '/sessions/logout' do
        warden.logout
        flash.next[:alert] = 'User Successfully signed out'
        redirect to '/sessions/new'
      end

      app.get '/unauthenticated' do
        flash.now[:error] = 'You are not authorised to view this page!'
        erb :'/sessions/unauthenticated'
      end

      app.get '/sessions/new' do
        if current_user
          flash.next[:alert] = 'Already signed in!'
          redirect back
        end

        erb :'/sessions/new'
      end

      app.post '/sessions' do
        warden.authenticate!
        flash.next[:alert] = 'User Successfully signed in'
        redirect to '/'
      end
    end
  end

  register SessionRoutes
end
