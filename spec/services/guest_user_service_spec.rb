require 'rails_helper'

RSpec.describe GuestUserService, type: :controller do
  describe '#call' do
    subject(:service) { GuestUserService.call(params, cart) }
    let(:params) { { email: 'user@spec.io', first_name: 'John', last_name: 'Doe' } }

    context 'when user is created' do
      let(:cart) { create(:cart) }

      it 'returns a not guest user' do
        service

        expect(User.first).not_to be_guest
      end
    end

    context 'when user is not created' do
      let(:cart) { create(:cart, user_id: nil) }

      it 'returns a guest user' do
        service

        expect(User.first).to be_guest
      end
    end
  end
end
