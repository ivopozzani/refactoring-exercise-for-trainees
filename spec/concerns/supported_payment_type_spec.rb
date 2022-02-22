require 'rails_helper'

RSpec.describe SupportedPaymentType, type: :controller do
  include SupportedPaymentType

  describe '#payment_type_supported?' do
    context 'when valid' do
      it 'returns true' do
        expect(payment_type_supported?('paypal')).to be true
      end
    end

    context 'when not valid' do
      it 'returns false' do
        expect(payment_type_supported?('invalid')).to be false
      end
    end
  end
end
