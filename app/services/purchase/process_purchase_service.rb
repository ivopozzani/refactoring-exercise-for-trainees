module Purchase
  class ProcessPurchaseService < Purchase::ApplicationService
    def initialize(params)
      @gateway = params.fetch(:gateway, nil)
      @cart_id = params.fetch(:cart_id, nil)
      @user_params = params.fetch(:user, nil)
      @address = params.fetch(:address, nil)
    end

    def call
      unless valid_gateway?
        return Purchase::PurchaseResultService.new(errors: ['Gateway not supported!'],
                                                   success: false)
      end

      cart = Cart.find_by(@cart_id)
      unless cart
        return Purchase::PurchaseResultService.new(errors: ['Cart not found!'],
                                                   success: false)
      end

      user = GetUserService.call(cart, @user_params)

      if user.valid?
        ProcessOrderService.call(cart, user, @address)
      else
        Purchase::PurchaseResultService.new(errors: user.errors.map(&:full_message),
                                            success: false)
      end
    end

    private

    def valid_gateway?
      Payment::PaymentContextService.new(@gateway).allowed?
    end
  end
end
