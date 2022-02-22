class GuestUserService
  def self.call(params, cart)
    new(params, cart).call
  end

  def initialize(params, cart)
    @params = params
    @cart = cart
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