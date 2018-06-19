# frozen_string_literal: true

require 'sequel'
require 'rest_client'

Sequel.connect("sqlite://fakebook-#{ENV['RACK_ENV']}.db", logger: Logger.new('log/db.log'))

require './models/user'
