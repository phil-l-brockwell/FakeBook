# frozen_string_literal: true

require 'sequel'
require 'rest_client'
require 'securerandom'

namespace :db do
  desc 'Create the database for the app'
  task :create, :env do
    db_name = "fakebook-#{ENV['env']}"

    Sequel.connect("sqlite://#{db_name}.db", logger: Logger.new('log/db.log'))
    puts "Successfully created db: #{db_name}"
  end

  desc 'Run migrations'
  task :migrate, :env do
    db_name = "fakebook-#{ENV['env']}"

    `sequel -m db/migrations sqlite://#{db_name}.db`
    puts "Successfully migrated db: #{db_name}"
  end

  desc 'Rollback most recently applied migration'
  task :rollback, :env do
    db_name = "fakebook-#{ENV['env']}"

    `sequel -M db/migrations sqlite://#{db_name}.db`
    puts "Successfully rolled back db: #{db_name}"
  end
end

namespace :secrets do
  desc 'Create the secrets file'
  task :create do
    rack_session_cookie_secret = SecureRandom.uuid

    File.open('secrets.env', 'w') { |file| file.write "export RACK_SESSION_COOKIE_SECRET=#{rack_session_cookie_secret}" }
    puts 'Successfully created secrets.env'
  end
end
