# frozen_string_literal: true

require './lib/response/success.rb'

describe Response::Success do
  subject { described_class.new }

  context '#initialize' do
    it 'is a success' do
      expect(subject.success?).to eq(true)
    end

    context 'with details' do
      subject { described_class.new(something: 'something') }

      it 'has the details' do
        expect(subject.details[:something]).to eq('something')
      end
    end
  end
end
