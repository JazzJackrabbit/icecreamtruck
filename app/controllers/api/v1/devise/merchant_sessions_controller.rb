class Api::V1::Devise::MerchantSessionsController < DeviseTokenAuth::SessionsController
  skip_before_action :verify_authenticity_token
end