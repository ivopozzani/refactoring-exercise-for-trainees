module Payment
  class PaymentContext
    attr_writer :payment_method
  
    def initialize(payment_method)
      @payment_method = payment_method
    end

    def set_payment_method(payment_method)
      @payment_method = payment_method
    end

    def method_accepted?
      if @payment_method == 'paypal'
        Payment::PaymentPaypal.new.method_implemented?
      elsif @payment_method == 'stripe'
        Payment::PaymentStripe.new.method_implemented?
      else
        false
      end
    end
  end
end