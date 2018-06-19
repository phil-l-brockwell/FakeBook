# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :username, null: false
      String :password_hash, null: false
      String :coolpay_username
      String :coolpay_api_key
      String :coolpay_api_token
    end
  end
end
