module Purchase
  class PurchaseResultService
    attr_reader :errors, :success, :object

    def initialize(purchase)
      @errors = purchase[:errors]
      @success = purchase[:success]
      @object = purchase[:object]
    end

    def successful?
      success
    end
  end
end
