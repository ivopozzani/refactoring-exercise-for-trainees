class PurchasesController < ApplicationController
  def create
    purchase = Purchase::ProcessPurchaseService.call(purchase_params)

    if purchase.successful?
      render json: { status: :success, order: { id: purchase.object.id } }, status: :ok
    else
      render json: { errors: purchase.errors.map do |message|
                               { message: message }
                             end },
             status: :unprocessable_entity
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
