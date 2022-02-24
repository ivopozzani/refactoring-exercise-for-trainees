require 'rails_helper'

RSpec.describe Purchase::ProcessPurchaseService do
  describe '#call' do
    subject { Purchase::ProcessPurchaseService.call(gateway, cart_id, user, address) }

    let(:gateway) { 'paypal' }
    let(:cart) { create(:cart) }
    let(:cart_id) { '1' }
    let(:user) { cart.user }
    let(:address) do
      { address_1: 'add1', address_2: 'add2', city: 'city1', state: 'state1', country: 'country1', zip: '44444' }
    end
    context 'when successful' do
      it 'returns json with status "success" and order "id"' do
        expect(subject.render_json).to eq({ status: :success, order: { id: 1 } })
      end

      it 'returns status ok' do
        expect(subject.status).to eq(:ok)
      end

      it 'returns true' do
        expect(subject.successful?).to be true
      end
    end

    context 'when not successful' do
      describe 'for Gateway not supported' do
        let(:gateway) { 'invalid' }
        it 'returns json with erros message' do
          expect(subject.render_json).to eq({ errors: [{ message: 'Gateway not supported!' }] })
        end

        it 'returns status unprocessable_entity' do
          expect(subject.status).to eq(:unprocessable_entity)
        end

        it 'returns false' do
          expect(subject.successful?).to be false
        end
      end

      describe 'for Cart not found' do
        let(:user) { nil }
        it 'returns json with erros message' do
          expect(subject.render_json).to eq({:errors=>[{:message=>"Cart not found!"}]})
        end

        it 'returns status unprocessable_entity' do
          expect(subject.status).to eq(:unprocessable_entity)
        end

        it 'returns false' do
          expect(subject.successful?).to be false
        end
      end
    end
  end
end
