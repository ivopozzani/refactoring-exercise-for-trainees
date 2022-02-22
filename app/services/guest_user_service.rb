class GuestUserService < ApplicationService
  def initialize(cart, params)
    @cart = cart
    @params = params
  end

  private_class_method :new
  
  def call
    if @cart.user.nil?
      user_params = @params ? @params : {}
      User.create(**user_params.merge(guest: true))
    else
      @cart.user
    end
  end
end
