class Api::V1::Devise::MerchantRegistrationsController < DeviseTokenAuth::RegistrationsController
  def create
    render json: { success: false }, status: :forbidden
  end

  def update
    render json: { success: false }, status: :forbidden
  end

  def destroy
    render json: { success: false }, status: :forbidden
  end
end