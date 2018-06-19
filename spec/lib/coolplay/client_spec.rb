# frozen_string_literal: true

require './lib/coolpay/client.rb'

describe Coolpay::Client do
  subject { described_class.new(initialize_params) }
  let(:initialize_params) { { username: 'test_user', apikey: 'test_api_key' } }
  let(:api_token) { 'this-is-a-token' }
  let(:request_headers) { described_class::HTTP_HEADERS }
  let(:payment_currency) { described_class::DEFAULT_CURRENCY }
  let(:payment_amount) { 10.5 }

  describe '#authenticate' do
    let(:path) { described_class::BASE_URL + 'login' }

    context 'success' do
      let(:json_body) { { token: api_token }.to_json }
      let(:api_response) { RestClient::Response.new(json_body) }

      before do
        allow(RestClient::Request).to receive(:execute)
          .with(method: :post, url: path, headers: request_headers.merge(params: initialize_params))
          .and_return(api_response)
      end

      it 'returns a success message' do
        response = subject.authenticate

        expect(response.success?).to eq(true)
        expect(response.details['token']).to eq(api_token)
      end
    end

    context 'error' do
      context 'with no username' do
        let(:initialize_params) { { apikey: 'test_api_key' } }

        it 'returns an error message' do
          response = subject.authenticate

          expect(response.success?).to eq(false)
          expect(response.error_message).to eq('username and/or apikey not present!')
        end
      end

      context 'with no password' do
        let(:initialize_params) { { username: 'test_user' } }

        it 'returns an error message' do
          response = subject.authenticate

          expect(response.success?).to eq(false)
          expect(response.error_message).to eq('username and/or apikey not present!')
        end
      end

      context 'with invalid params' do
        let(:initialize_params) { { username: 'invalid_user', apikey: 'invalid_apikey' } }
        let(:api_response) { RestClient::NotFound.new }

        before do
          allow(RestClient::Request).to receive(:execute)
            .with(method: :post, url: path, headers: request_headers.merge(params: initialize_params))
            .and_raise(api_response)
        end

        it 'returns an error message' do
          response = subject.authenticate

          expect(response.success?).to eq(false)
          expect(response.error_message).to eq('username and/or apikey invalid!')
        end
      end
    end
  end

  describe '#add_recipient' do
    let(:initialize_params) { { username: 'test_user', apikey: 'test_api_key', api_token: api_token } }
    let(:path) { described_class::BASE_URL + 'recipients' }
    let(:new_recipient) { 'Boots McGoots' }
    let(:request_body) { { recipient: { name: new_recipient } } }
    let(:request_headers) { described_class::HTTP_HEADERS.merge(Authorization: "Bearer #{api_token}") }
    let(:response_body) { { recipient: { name: new_recipient, id: 'a0c1f0b1-f97c-400a-8f14-51c8038a1eca' } }.to_json }

    context 'success' do
      context 'with a new recipient' do
        before do
          allow(RestClient::Request).to receive(:execute)
            .with(method: :post, url: path, headers: request_headers.merge(params: request_body))
            .and_return(api_response)
        end

        let(:api_response) { RestClient::Response.new(response_body) }

        it 'returns the new details' do
          response = subject.add_recipient(new_recipient)

          expect(response.success?).to eq(true)
          expect(response.details['recipient']['id']).to eq('a0c1f0b1-f97c-400a-8f14-51c8038a1eca')
        end
      end
    end

    context 'error' do
      context 'with an invalid api_token' do
        let(:api_response) { RestClient::Unauthorized.new }

        before do
          allow(RestClient::Request).to receive(:execute)
            .with(method: :post, url: path, headers: request_headers.merge(params: request_body))
            .and_raise(api_response)
        end

        it 'returns an error message' do
          response = subject.add_recipient(new_recipient)

          expect(response.success?).to eq(false)
          expect(response.error_message).to eq('invalid api_token!')
        end
      end

      context 'without an api_token' do
        let(:api_token) { nil }

        it 'returns an error message' do
          response = subject.add_recipient(new_recipient)

          expect(response.success?).to eq(false)
          expect(response.error_message).to eq('api_token not present! Ensure your credentials are correct and authenticated')
        end
      end

      context 'with an empty name string' do
        it 'returns an error message' do
          response = subject.add_recipient('')

          expect(response.success?).to eq(false)
          expect(response.error_message).to eq('invalid recipient_name!')
        end
      end
    end
  end

  describe '#get_recipients' do
    let(:initialize_params) { { username: 'test_user', apikey: 'test_api_key', api_token: api_token } }
    let(:path) { described_class::BASE_URL + 'recipients' }
    let(:request_headers) { described_class::HTTP_HEADERS.merge(Authorization: "Bearer #{api_token}") }
    let(:recipients) { { recipients: [{ 'name' => 'Boots McGoots', 'id' => '12345' }, { 'name' => 'Robert Pulson', 'id' => 'abcde' }] } }
    let(:api_response) { RestClient::Response.new(recipients.to_json) }

    context 'success' do
      before do
        allow(RestClient::Request).to receive(:execute)
          .with(method: :get, url: path, headers: request_headers.merge(params: nil))
          .and_return(api_response)
      end

      it 'returns the recipients' do
        response = subject.get_recipients

        expect(response.success?).to eq(true)
        expect(response.details['recipients']).to eq(recipients[:recipients])
      end
    end

    context 'error' do
      context 'with an invalid api_token' do
        let(:api_response) { RestClient::Unauthorized.new }

        before do
          allow(RestClient::Request).to receive(:execute)
            .with(method: :get, url: path, headers: request_headers.merge(params: nil))
            .and_raise(api_response)
        end

        it 'returns an error message' do
          response = subject.get_recipients

          expect(response.success?).to eq(false)
          expect(response.error_message).to eq('invalid api_token!')
        end
      end

      context 'without an api_token' do
        let(:api_token) { nil }

        it 'returns an error message' do
          response = subject.get_recipients

          expect(response.success?).to eq(false)
          expect(response.error_message).to eq('api_token not present! Ensure your credentials are correct and authenticated')
        end
      end
    end
  end

  describe '#add_payment' do
    let(:path) { described_class::BASE_URL + 'payments' }
    let(:recipient_id) { '123-456-789' }
    let(:request_headers) { described_class::HTTP_HEADERS.merge(Authorization: "Bearer #{api_token}") }
    let(:request_body) { { payment: { amount: payment_amount, currency: payment_currency, recipient_id: recipient_id } } }
    let(:initialize_params) { { username: 'test_user', apikey: 'test_api_key', api_token: api_token } }

    context 'success' do
      let(:response_body) do
        {
          payment: {
            'id' => '987-654-321',
            'amount' => payment_amount,
            'currency' => payment_currency.to_s,
            'recipient_id' => recipient_id,
            'status' => 'processing'
          }
        }
      end
      let(:api_response) { RestClient::Response.new(response_body.to_json) }

      before do
        allow(RestClient::Request).to receive(:execute)
          .with(method: :post, url: path, headers: request_headers.merge(params: request_body))
          .and_return(api_response)
      end

      it 'returns the payment details' do
        response = subject.add_payment(payment_amount, recipient_id)

        expect(response.success?).to eq(true)
        expect(response.details['payment']).to eq(response_body[:payment])
      end
    end

    context 'error' do
      before do
        allow(RestClient::Request).to receive(:execute)
          .with(method: :post, url: path, headers: request_headers.merge(params: request_body))
          .and_raise(api_response)
      end

      context 'with an invalid api_token' do
        let(:api_response) { RestClient::Unauthorized.new }

        it 'returns an error message' do
          response = subject.add_payment(payment_amount, recipient_id)

          expect(response.success?).to eq(false)
          expect(response.error_message).to eq('invalid api_token!')
        end
      end

      context 'without an api_token' do
        let(:api_token) { nil }
        let(:api_response) { RestClient::InternalServerError.new }

        it 'returns an error message' do
          response = subject.add_payment(payment_amount, recipient_id)

          expect(response.success?).to eq(false)
          expect(response.error_message).to eq('api_token not present! Ensure your credentials are correct and authenticated')
        end
      end

      context 'with an invalid recipient_id' do
        let(:api_response) { RestClient::InternalServerError.new }

        it 'returns an error message' do
          response = subject.add_payment(payment_amount, recipient_id)

          expect(response.success?).to eq(false)
          expect(response.error_message).to eq('recipient_id does not exist!')
        end
      end
    end
  end

  describe '#get_payments' do
    let(:path) { described_class::BASE_URL + 'payments' }
    let(:request_headers) { described_class::HTTP_HEADERS.merge(Authorization: "Bearer #{api_token}") }
    let(:initialize_params) { { username: 'test_user', apikey: 'test_api_key', api_token: api_token } }

    context 'success' do
      let(:response_body) do
        {
          payments: [
            {
              'id' => '31db334f-9ac0-42cb-804b-09b2f899d4d2',
              'amount' => payment_amount,
              'currency' => payment_currency.to_s,
              'recipient_id' => '6e7b146e-5957-11e6-8b77-86f30ca893d3',
              'status' => 'paid'
            }
          ]
        }
      end
      let(:api_response) { RestClient::Response.new(response_body.to_json) }

      before do
        allow(RestClient::Request).to receive(:execute)
          .with(method: :get, url: path, headers: request_headers.merge(params: nil))
          .and_return(api_response)
      end

      it 'returns the payments' do
        response = subject.get_payments

        expect(response.success?).to eq(true)
        expect(response.details['payments']).to eq(response_body[:payments])
      end
    end

    context 'error' do
      before do
        allow(RestClient::Request).to receive(:execute)
          .with(method: :get, url: path, headers: request_headers.merge(params: nil))
          .and_raise(api_response)
      end

      context 'without an api_token' do
        let(:api_token) { nil }
        let(:api_response) { RestClient::InternalServerError.new }

        it 'returns an error message' do
          response = subject.get_payments

          expect(response.success?).to eq(false)
          expect(response.error_message).to eq('api_token not present! Ensure your credentials are correct and authenticated')
        end
      end

      context 'with an invalid api_token' do
        let(:api_response) { RestClient::Unauthorized.new }

        it 'returns an error message' do
          response = subject.get_payments

          expect(response.success?).to eq(false)
          expect(response.error_message).to eq('invalid api_token!')
        end
      end
    end
  end
end
