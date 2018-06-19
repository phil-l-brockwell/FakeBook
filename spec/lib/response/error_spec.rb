# frozen_string_literal: true

require './lib/response/error.rb'

describe Response::Error do
  subject { described_class.new }

  context '#initialize' do
    it 'is not a success' do
      expect(subject.success?).to eq(false)
    end

    it 'has the default error_message' do
      expect(subject.error_message).to eq('Something went wrong!')
    end

    context 'with a custom error_message' do
      subject { described_class.new(error_message: custom_error_message) }
      let(:custom_error_message) { 'This is a custom error_message!' }

      it 'has the error_message' do
        expect(subject.error_message).to eq(custom_error_message)
      end
    end
  end
end
