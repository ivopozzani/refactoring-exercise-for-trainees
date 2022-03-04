require 'rails_helper'

RSpec.describe ProcessOrderService, type: :controller do
  subject { ProcessOrderService.call(cart, user, params) }
  let(:cart) { create(:cart) }
  let(:user) { cart.user }
  let(:params) do
    { address_1: 'add1', address_2: 'add2', city: 'city1', state: 'state1', country: 'country1', zip: '44444' }
  end

  context 'when valid' do
    describe '.call' do
      it 'creates new order' do
        expect { subject }.to change(Order, :count).by(1)
      end

      it 'returns instance of "Purchase::PurchaseResultService"' do
        expect(subject).to be_instance_of(Purchase::PurchaseResultService)
      end
    end

    describe '#object' do
      it 'returns last order object' do
        subject
        expect(subject.object).to eq(Order.last)
      end
    end

    describe '#errors' do
      it 'returns nil' do
        subject
        expect(subject.errors).to be nil
      end
    end

    describe '#success' do
      it 'returns true' do
        subject
        expect(subject.success).to be true
      end
    end

    context 'when not valid' do
      before do
        allow(ProcessOrderService).to receive(:call).and_return(Purchase::PurchaseResultService.new(errors: ['new error'],
                                                                                                    success: false))
      end

      describe '.call' do
        it 'creates new order' do
          expect { subject }.not_to change(Order, :count)
        end

        it 'returns instance of "Purchase::PurchaseResultService"' do
          expect(subject).to be_instance_of(Purchase::PurchaseResultService)
        end
      end

      describe '#object' do
        it 'returns last order object' do
          subject
          expect(subject.object).to be nil
        end
      end

      describe '#errors' do
        it 'returns nil' do
          subject
          expect(subject.errors).to eq(['new error'])
        end
      end

      describe '#success' do
        it 'returns false' do
          subject
          expect(subject.success).to be false
        end
      end
    end
  end
end
