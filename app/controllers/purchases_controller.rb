class PurchasesController < ApplicationController
  include SupportedPaymentType

  def create    
    if payment_type_supported?(purchase_params[:gateway])
      cart_id = purchase_params[:cart_id]
      
      cart = Cart.find_by(id: cart_id)

      unless cart
        return render json: { errors: [{ message: 'Cart not found!' }] }, status: :unprocessable_entity
      end

      user = GuestUserService.call(purchase_params[:user], cart)
     
      if user.valid?
        order = ProcessOrderService.call(cart, user, purchase_params[:address])
        
        if order.valid?
          return render json: { status: :success, order: { id: order.id } }, status: :ok
        else
          return render json: { errors: order.errors.map(&:full_message).map { |message| { message: message } } }, status: :unprocessable_entity
        end
      else
        return render json: { errors: user.errors.map(&:full_message).map { |message| { message: message } } }, status: :unprocessable_entity
      end
    else
      render json: { errors: [{ message: 'Gateway not supported!' }] }, status: :unprocessable_entity
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
end
