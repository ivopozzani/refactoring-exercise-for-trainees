class GetUserService < ApplicationService
  def initialize(cart, params)
    @cart = cart
    @params = params || {}
  end

  def call
    if @cart.user.nil?
      User.create(@params.merge(guest: true))
    else
      @cart.user
    end
  end
end
