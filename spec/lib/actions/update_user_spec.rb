# frozen_string_literal: true

require 'spec_helper'
require './lib/actions/update_user'

describe UpdateUser do
  describe '#perform' do
    subject { described_class.new(params) }
    let(:response) { subject.perform }
    let(:user) { User.create(username: 'Robert Pulson', password: 'password') }
    let(:user_id) { user.id }

    context 'success' do
      context 'updating the username' do
        let(:params) { { id: user_id, username: 'New Username' } }

        it 'returns a success message' do
          expect(response.success?).to eq(true)
          expect(user.reload.username).to eq(params[:username])
        end
      end

      context 'updating the coolpay_username' do
        let(:params) { { id: user_id, coolpay_username: 'cool' } }

        it 'returns a success message' do
          expect(response.success?).to eq(true)
          expect(user.reload.coolpay_username).to eq(params[:coolpay_username])
        end
      end

      context 'updating the coolpay_api_key' do
        let(:params) { { id: user_id, coolpay_api_key: 'api-key' } }

        it 'returns a success message' do
          expect(response.success?).to eq(true)
          expect(user.reload.coolpay_api_key).to eq(params[:coolpay_api_key])
        end
      end

      context 'updating the coolpay_api_token' do
        let(:params) { { id: user_id, coolpay_api_token: 'api-token' } }

        it 'returns a success message' do
          expect(response.success?).to eq(true)
          expect(user.reload.coolpay_api_token).to eq(params[:coolpay_api_token])
        end
      end
    end

    context 'error' do
      context 'with an invalid user' do
        let(:params) { { id: 99, username: 'something' } }

        it 'returns an error response' do
          expect(response.success?).to eq(false)
          expect(response.error_message).to eq('User not found!')
        end
      end

      context 'with an invalid username' do
        let(:params) { { id: user_id, username: 'short' } }

        it 'returns an error response' do
          expect(response.success?).to eq(false)
          expect(response.error_message).to eq('Invalid Username! Must be atleast 8 characters')
        end
      end

      context 'with an invalid password' do
        let(:params) { { id: user_id, password: 'short' } }

        it 'returns an error response' do
          expect(response.success?).to eq(false)
          expect(response.error_message).to eq('Invalid Password! Must be atleast 6 characters')
        end
      end
    end
  end
end
