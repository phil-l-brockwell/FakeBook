# frozen_string_literal: true

require 'spec_helper'

describe User do
  subject { described_class.new }

  describe '#coolpay_authenticated?' do
    it 'returns true when an api_token is present' do
      subject.coolpay_api_token = '123-456-789'

      expect(subject.coolpay_authenticated?).to eq(true)
    end

    it 'returns false when an api_token is not present' do
      expect(subject.coolpay_authenticated?).to eq(false)
    end
  end
end
