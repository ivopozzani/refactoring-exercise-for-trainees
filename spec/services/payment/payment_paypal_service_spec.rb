require 'rails_helper'

RSpec.describe Payment::PaymentPaypalService do
  describe '#implemented?' do
    it 'returns true' do
      expect(Payment::PaymentPaypalService.new.method_implemented?).to be true
    end
  end
end
