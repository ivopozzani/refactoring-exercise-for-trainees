module Payment
  class PaymentStripe < PaymentMethod
    def method_implemented?
      true
    end 
  end
end
