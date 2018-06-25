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

namespace :app do
  desc 'Initialize the app'
  task :init do
    puts '- Create dependencies'
    `bundle`

    puts '- Create the db log file'
    `touch log/db.log`

    puts '- Create the databases'
    `rake db:create env=test && rake db:create env=development`

    puts '- Migrate the databases'
    `rake db:migrate env=test && rake db:migrate env=development`

    puts '- Create the secrets'
    `rake secrets:create`

    puts 'Successfully initialized Fakebook!'
    puts 'run "bundle exec rackup -p 3000" to start the server and check it out at "http://localhost:3000/" in your browser'
  end
end
