require 'rails_helper'

RSpec.describe Payment::PaymentContextService do
  describe '#method_accepted?' do    
    context 'when valid' do
      it 'selects paypal' do
        param = 'paypal'
        expect(Payment::PaymentContextService.new(param).method_accepted?).to be true
      end

      it 'selects stripe' do
        param = 'stripe'
        expect(Payment::PaymentContextService.new(param).method_accepted?).to be true
      end
    end

    context 'when not valid' do
      it 'returns false' do
        param = 'foo'
        expect(Payment::PaymentContextService.new(param).method_accepted?).to be false
      end
    end
  end
end
