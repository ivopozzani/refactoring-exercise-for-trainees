module Purchase
  class PurchaseResultService
    attr_reader :render_json, :status

    def initialize(render_json, status)
      @render_json = render_json
      @status = status
    end

    def successful?
      status == :ok
    end
  end
end
