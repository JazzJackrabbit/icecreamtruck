require 'rails_helper'

RSpec.describe "Api::V1::Auth", type: :request do
  describe "POST /api/v1/auth/sign_in" do 
    let (:merchant) { create(:merchant) }
    before { merchant.create_new_auth_token }


    it "succeeds with correct email and password" do
      params = {
        email: merchant.email,
        password: merchant.password
      }

      post '/api/v1/auth/sign_in', params: params
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["data"]["email"]).to eq(merchant.email)
    end

    it 'gives an authentication token when successful' do
      params = {
        email: merchant.email,
        password: merchant.password
      }

      post '/api/v1/auth/sign_in', params: params
      
      expect(response.has_header?('access-token')).to eq(true)
    end

    it "fails with incorrect email and password" do
      params = {
        email: 'fake@email.com',
        password: merchant.password
      }

      post '/api/v1/auth/sign_in', params: params
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to have_key('errors')
    end
  end
end