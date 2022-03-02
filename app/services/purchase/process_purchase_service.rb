module Purchase
  class ProcessPurchaseService < Purchase::ApplicationService
    def initialize(params)
      @gateway = params.fetch(:gateway, nil)
      @cart_id = params.fetch(:cart_id, nil)
      @user_params = params.fetch(:user, nil)
      @address = params.fetch(:address, nil)
    end

    def call
      unless Payment::PaymentContextService.new(@gateway).method_accepted?
        return Purchase::PurchaseResultService.new(
          errors: [{ message: 'Gateway not supported!' }], success: false
        )
      end

      cart = Cart.find_by(@cart_id)
      unless cart
        return Purchase::PurchaseResultService.new(
          errors: [{ message: 'Cart not found!' }], success: false
        )
      end

      user = GetUserService.call(cart, @user_params)

      if user.valid?
        ProcessOrderService.call(cart, user, @address)
      else
        Purchase::PurchaseResultService.new(
          errors: user.errors.map(&:full_message).map do |message|
                    { message: message }
                  end,
          success: false
        )
      end
    end
  end
end
