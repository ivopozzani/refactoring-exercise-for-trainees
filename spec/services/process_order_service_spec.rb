require 'rails_helper'

RSpec.describe ProcessOrderService, type: :controller do
  describe '#call' do
    let(:cart) { create(:cart) }
    let(:user) { cart.user }
    let(:params) { nil }

    it 'creates new order' do
      expect { ProcessOrderService.call(cart, user, params) }.to change(Order, :count).by(1)
    end

    it 'returns order object' do
      expect(ProcessOrderService.call(cart, user, params)).to eq(Order.first)
    end
  end
end
