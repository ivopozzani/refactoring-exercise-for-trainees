require 'rails_helper'

RSpec.describe Purchase::PurchaseResultService do
  subject { Purchase::PurchaseResultService.new(render_json, status) }
  let(:render_json) { { errors: [{ message: 'Error' }] } }
  let(:status) { :ok }
  
  describe '#render_json' do
    it 'returns render_json' do
      expect(subject.render_json).to eq(render_json)
    end
  end

  describe '#status' do
    it 'returns status' do
      expect(subject.status).to eq(status)
    end
  end

  describe '#successful?' do
    context 'when status is "ok"' do
      let(:status) { :ok }
      it 'returns true' do
        expect(subject.successful?).to be true
      end
    end

    context 'when status is not "ok"' do
      let(:status) { :unprocessable_entity }
      it 'returns false' do
        expect(subject.successful?).to be false
      end
    end
  end
end
