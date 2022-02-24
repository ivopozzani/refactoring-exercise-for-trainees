require 'rails_helper'

RSpec.describe ProcessOrderService, type: :controller do
  describe '#call' do
    let(:cart) { create(:cart) }
    let(:user) { cart.user }
    let(:params) do
      { address_1: 'add1', address_2: 'add2', city: 'city1', state: 'state1', country: 'country1', zip: '44444' }
    end

    it 'creates new order' do
      expect { ProcessOrderService.call(cart, user, params) }.to change(Order, :count).by(1)
    end

    it 'returns order object' do
      expect(ProcessOrderService.call(cart, user, params)).to eq(Order.last)
    end
  end
end
