require 'rails_helper'

RSpec.describe Purchase::ProcessPurchaseService do
  describe '.call' do
    subject { Purchase::ProcessPurchaseService.call(params) }
    let(:cart) { create(:cart) }
    let(:params) do
      {
        gateway: gateway,
        cart_id: cart_id,
        user: user,
        address: {
          address_1: 'add1',
          address_2: 'add2',
          city: 'city1',
          state: 'state1',
          country: 'country1',
          zip: '44444'
        }
      }
    end

    context 'when successful' do
      let(:gateway) { 'paypal' }
      let(:cart_id) { '1' }
      let(:user) { cart.user }

      describe '#errors' do
        it 'returns no errors' do
          expect(subject.errors).to eq(nil)
        end
      end

      describe '#success' do
        it 'returns "true"' do
          expect(subject.success).to eq(true)
        end
      end

      describe '#object' do
        it 'returns Order Object' do
          expect(subject.object).to eq(Order.last)
        end
      end

      describe '#successful?' do
        it 'returns true' do
          expect(subject.successful?).to be true
        end
      end
    end

    context 'when not successful' do
      let(:gateway) { 'paypal' }
      let(:cart_id) { '1' }
      let(:user) { cart.user }

      describe 'for Gateway not supported' do
        let(:gateway) { 'invalid' }

        it 'returns message "Gateway not supported!"' do
          expect(subject.errors).to eq(['Gateway not supported!'])
        end

        it 'returns success "false"' do
          expect(subject.success).to be false
        end

        it 'returns successful? "false"' do
          expect(subject.successful?).to be false
        end
      end

      describe 'for Cart not found' do
        let(:user) { nil }

        it 'returns message "Cart not found!"' do
          expect(subject.errors).to eq(['Cart not found!'])
        end

        it 'returns success "false"' do
          expect(subject.success).to be false
        end

        it 'returns successful? "false"' do
          expect(subject.successful?).to be false
        end
      end
    end
  end
end
