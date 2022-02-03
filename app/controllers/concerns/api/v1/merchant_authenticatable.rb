module Api::V1::MerchantAuthenticatable
  extend ActiveSupport::Concern

  def authenticate_merchant!
    send(:authenticate_api_v1_merchant!, force: true)
  end

  def current_merchant
    current_api_v1_merchant
  end
end