module Payment
  class PaymentContext
    attr_writer :payment_method
  
    def initialize(payment_method)
      @payment_method = payment_method
    end

    def method_accepted?
      case @payment_method
      when 'paypal'
        Payment::PaymentPaypal.new.method_implemented?
      when 'stripe'
        Payment::PaymentStripe.new.method_implemented?
      else
        false
      end
    end
  end
end
