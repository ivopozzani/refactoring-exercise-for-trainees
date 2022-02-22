class PurchasesController < ApplicationController
  include SupportedPaymentType

  def create
    if payment_type_supported?(purchase_params[:gateway])
      cart = Cart.find_by(purchase_params[:cart_id])

      return render_message_error('Cart not found!') unless cart

      user = GuestUserService.call(purchase_params[:user], cart)

      if user.valid?
        order = ProcessOrderService.call(cart, user, purchase_params[:address])

        if order.valid?
          render_order_success(order.id)
        else
          render_object_error(order)
        end
      else
        render_object_error(user)
      end
    else
      render_message_error('Gateway not supported!')
    end
  end

  private

  def purchase_params
    params.permit(
      :gateway,
      :cart_id,
      user: %i[email first_name last_name],
      address: %i[address_1 address_2 city state country zip]
    )
  end

  def render_message_error(e)
    render json: { errors: [{ message: e }] }, status: :unprocessable_entity
  end

  def render_object_error(obj)
    render json: { errors: obj.errors.map(&:full_message).map do |message| 
      { message: message } end }, 
      status: :unprocessable_entity
  end

  def render_order_success(order)
    render json: { status: :success, order: { id: order } }, status: :ok
  end
end
