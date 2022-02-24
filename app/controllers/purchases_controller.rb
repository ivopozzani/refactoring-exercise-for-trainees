class PurchasesController < ApplicationController
  def create
    purchase = Purchase::ProcessPurchaseService.call(purchase_params[:gateway], purchase_params[:cart_id],
                                                    purchase_params[:user], purchase_params[:address])

    if purchase.successful?
      render_message(purchase.render_json, purchase.status)
    else
      render_message(purchase.render_json, purchase.status)
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

  def render_message(json, status)
    render json: json, status: status
  end
end
