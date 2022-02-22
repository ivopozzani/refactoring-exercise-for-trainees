module SupportedPaymentType
  extend ActiveSupport::Concern

  SUPPORTED_PAYMENT_TYPES = ['paypal', 'stripe'].freeze

  def payment_type_supported? (payment_type)
    SUPPORTED_PAYMENT_TYPES.include?(payment_type)
  end
end
