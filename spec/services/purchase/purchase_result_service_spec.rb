require 'rails_helper'

RSpec.describe Purchase::PurchaseResultService do
  subject { Purchase::PurchaseResultService.new(errors: errors, success: success) }
  let(:errors) { [{ message: 'Error' }] }
  let(:success) { true }

  describe '#errors' do
    it 'returns errors' do
      expect(subject.errors).to eq(errors)
    end
  end

  describe '#success' do
    it 'returns success' do
      expect(subject.success).to eq(success)
    end
  end

  describe '#successful?' do
    context 'when success is "true"' do
      it 'returns true' do
        expect(subject.successful?).to be true
      end
    end

    context 'when success is "false"' do
      let(:success) { false }
      it 'returns false' do
        expect(subject.successful?).to be false
      end
    end
  end
end
