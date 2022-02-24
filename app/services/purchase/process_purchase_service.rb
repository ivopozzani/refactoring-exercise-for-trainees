module Purchase
  class ProcessPurchaseService < Purchase::ApplicationService
    PAYMENT_METHOD = %w[paypal stripe]

    def initialize(gateway, cart_id, user_params, address)
      @gateway = gateway
      @cart_id = cart_id
      @user_params = user_params
      @address = address
    end

    def call
      unless Payment::PaymentContextService.new(@gateway).method_accepted?
        return Purchase::PurchaseResultService.new(
          { errors: [{ message: 'Gateway not supported!' }] }, :unprocessable_entity
        )
      end

      cart = Cart.find_by(@cart_id)
      unless cart
        return Purchase::PurchaseResultService.new(
          { errors: [{ message: 'Cart not found!' }] }, :unprocessable_entity
        )
      end

      user = GetUserService.call(cart, @user_params)

      if user.valid?
        order = ProcessOrderService.call(cart, user, @address)

        if order.valid?
          Purchase::PurchaseResultService.new(
            { status: :success, order: { id: order.id } }, :ok
          )
        else
          Purchase::PurchaseResultService.new(
            { errors: order.errors.map(&:full_message).map do |message|
                        { message: message }
                      end },
            :unprocessable_entity
          )
        end
      else
        Purchase::PurchaseResultService.new(
          { errors: user.errors.map(&:full_message).map do |message|
                      { message: message }
                    end },
          :unprocessable_entity
        )
      end
    end
  end
end
