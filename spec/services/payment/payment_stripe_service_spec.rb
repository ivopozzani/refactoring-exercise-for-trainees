require 'rails_helper'

RSpec.describe Payment::PaymentStripeService do
  describe '#implemented?' do
    it 'returns true' do
      expect(Payment::PaymentStripeService.new.method_implemented?).to be true
    end
  end
end
