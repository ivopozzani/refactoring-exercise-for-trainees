module Payment
  class PaymentPaypal < PaymentMethod
    def method_implemented?
      true
    end 
  end
end
