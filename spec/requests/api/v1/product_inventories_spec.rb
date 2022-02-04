require 'rails_helper'
require 'auth_helper'

describe "PUT /api/v1/trucks/:id/inventory", type: :request do
  before { 
    @truck = create :truck, :with_products
    @product_inventory = @truck.inventories.where(product_id: @truck.products.first.id).first
    @auth_params = create_auth_headers
  }

  context "when authenticated" do
    it 'returns status code 200' do
      old_quantity = @product_inventory.quantity

      params = {
        product_id: @product_inventory.product_id,
        quantity: old_quantity+1
      }
      
      put "/api/v1/trucks/#{@truck.id}/inventory", params: params, headers: @auth_params

      expect(response).to have_http_status(:success)
      data = JSON.parse(response.body)['data']
      expect(data['inventory']['quantity']).to eq(old_quantity+1)
    end


    it 'responds with an error when parameters are missing from request' do
      params = {}
      put "/api/v1/trucks/#{@truck.id}/inventory", headers: @auth_params

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'responds with an error when invalid product id is provided' do
      fake_product_id = 999

      params = {
        product_id: fake_product_id,
        quantity: 100
      }

      put "/api/v1/trucks/#{@truck.id}/inventory", params: params, headers: @auth_params

      data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'responds with an error when invalid product quantity is provided' do
      invalid_quantity = -1

      params = {
        product_id: @product_inventory.product_id,
        quantity: invalid_quantity
      }

      put "/api/v1/trucks/#{@truck.id}/inventory", params: params, headers: @auth_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'responds with an error when invalid truck id is provided' do
      fake_truck_id = 999

      params = {
        product_id: @product_inventory.product_id,
        quantity: 100
      }

      put "/api/v1/trucks/#{fake_truck_id}/inventory", params: params, headers: @auth_params
      expect(response).to have_http_status(:not_found)
    end
  end

  context "when not authenticated" do
    it 'returns status code 401' do
      params = {
        product_id: @product_inventory.product_id,
        quantity: @product_inventory.quantity+1
      }
      
      put "/api/v1/trucks/#{@truck.id}/inventory", params: params
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

describe "GET /api/v1/trucks/:id/inventory", type: :request do
  before(:all) { 
    @truck = create :truck, :with_products
    @auth_params = create_auth_headers
  }

  context "when authorized" do
    before { get "/api/v1/trucks/#{@truck.id}/inventory", headers: @auth_params }

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'response contains information about truck inventory' do
      data = JSON.parse(response.body)['data']
      expect(data).to have_key('inventory')
    end
  end

  context "when not authorized" do
    before { get "/api/v1/trucks/#{@truck.id}/inventory" }

    it 'returns status code 401' do
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

describe 'DELETE /api/v1/trucks/:truck_id/inventory' do
  before { 
    @truck = create :truck, :with_products
    @auth_params = create_auth_headers
  }

  context "when authorized" do
    it 'destroy truck inventory record' do
      product_id = @truck.products.first.id
      params = { 
        product_id: product_id
      }
      delete "/api/v1/trucks/#{@truck.id}/inventory", params: params, headers: @auth_params
      expect(response).to have_http_status(:ok)
      expect(@truck.inventory.products.map(&:id)).not_to include(product_id)
    end
  end

  context "when not authorized" do
    it 'returns status code 401' do
      params = { 
        product_id: @truck.products.first.id
      }
      delete "/api/v1/trucks/#{@truck.id}/inventory", params: params
      expect(response).to have_http_status(:unauthorized)
    end
  end
end