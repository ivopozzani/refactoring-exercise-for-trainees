require 'rails_helper'

RSpec.describe GetUserService, type: :controller do
  describe '#call' do
    subject(:service) { GetUserService.call(cart, params) }
    let(:params) { { email: 'user@user.io', first_name: 'Userfromparams', last_name: 'Doe' } }

    context 'when user exists' do
      let(:user) { create(:user) }
      let(:cart) { create(:cart, user_id: user.id) }

      it 'returns user' do
        expect(service).to eq(user)
      end

      it 'does not return guest user' do
        service

        expect(user).not_to be_guest
      end
    end

    context 'when user does not exist' do
      let(:cart) { create(:cart, user_id: nil) }

      it 'creates user' do
        expect { service }.to change(User, :count).by(1)
      end

      it 'returns user using attributes from params' do
        service

        expect(User.last.first_name).to eq('Userfromparams')
      end

      it 'returns guest user' do
        service

        expect(User.last).to be_guest
      end
    end
  end
end
