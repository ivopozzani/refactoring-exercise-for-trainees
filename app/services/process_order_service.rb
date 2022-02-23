class ProcessOrderService < ApplicationService
  SHIPPING_COSTS = 100

  def initialize(cart, user, params)
    @cart = cart
    @user = user
    @params = params || {}
  end

  def call
    order = new_order
    add_cart_itens_on(order)
    order.save
    order
  end

  private

  def new_order
    Order.new(
      user: @user,
      first_name: @user.first_name,
      last_name: @user.last_name,
      address_1: @params[:address_1],
      address_2: @params[:address_2],
      city: @params[:city],
      state: @params[:state],
      country: @params[:country],
      zip: @params[:zip]
    )
  end

  def add_cart_itens_on(order)
    @cart.items.each do |item|
      item.quantity.times do
        order.items << OrderLineItem.new(
          order: order,
          sale: item.sale,
          unit_price_cents: item.sale.unit_price_cents,
          shipping_costs_cents: SHIPPING_COSTS,
          paid_price_cents: item.sale.unit_price_cents + SHIPPING_COSTS
        )
      end
    end
  end
end
