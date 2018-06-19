# frozen_string_literal: true

require 'spec_helper'
require './lib/actions/register_user'

describe RegisterUser do
  describe '#perform' do
    subject { described_class.new(params) }
    let(:response) { subject.perform }

    context 'success' do
      let(:params) { { username: 'Robert Pulson', password: 'password' } }
      let(:user) { response.details[:user] }

      it 'returns a success response with the new user' do
        expect(response.success?).to eq(true)
        expect(user.username).to eq(params[:username])
        expect(user.password).to eq(params[:password])
      end
    end

    context 'error' do
      context 'with an invalid username' do
        let(:params) { { username: 'Robert', password: 'password' } }

        it 'returns an error message' do
          expect(response.success?).to eq(false)
          expect(response.error_message).to eq('Invalid Username! Must be atleast 8 characters')
        end
      end

      context 'with an invalid password' do
        let(:params) { { username: 'Robert Pulson', password: 'pass' } }

        it 'returns an error message' do
          expect(response.success?).to eq(false)
          expect(response.error_message).to eq('Invalid Password! Must be atleast 6 characters')
        end
      end
    end
  end
end
