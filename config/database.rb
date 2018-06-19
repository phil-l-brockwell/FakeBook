# frozen_string_literal: true

require 'sequel'

Sequel.connect("sqlite://fakebook-#{ENV['RACK_ENV']}.db", logger: Logger.new('log/db.log'))
