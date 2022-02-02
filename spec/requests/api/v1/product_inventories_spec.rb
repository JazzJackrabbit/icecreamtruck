require 'rails_helper'

describe "PUT /api/v1/trucks/:id/inventory", type: :request do
  let(:truck) { create(:truck, :with_products) }
  let(:product_inventory) { truck.inventories.where(product_id: truck.products.first.id).first }
  let(:old_quantity) { product_inventory.quantity }

  before {
    params = {
      product_id: product_inventory.product_id,
      quantity: old_quantity + 1
    }
    put "/api/v1/trucks/#{truck.id}/inventory", params: params
  }

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end

  it 'correctly updates truck inventory' do
    data = JSON.parse(response.body)['data']
    expect(data['inventory']['quantity']).to eq(old_quantity + 1)
  end

  it 'responds with an error when parameters are missing from request', :skip_before_hook do
    params = {}
    put "/api/v1/trucks/#{truck.id}/inventory"

    expect(response).to have_http_status(:unprocessable_entity)
  end

  it 'responds with an error when invalid product id is provided', :skip_before_hook do
    fake_product_id = 999

    params = {
      product_id: fake_product_id,
      quantity: 100
    }

    put "/api/v1/trucks/#{truck.id}/inventory", params: params

    data = JSON.parse(response.body)['data']
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it 'responds with an error when invalid product quantity is provided', :skip_before_hook do
    invalid_quantity = -1

    params = {
      product_id: product_inventory.product_id,
      quantity: invalid_quantity
    }

    put "/api/v1/trucks/#{truck.id}/inventory", params: params
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it 'responds with an error when invalid truck id is provided', :skip_before_hook do
    fake_truck_id = 999

    params = {
      product_id: product_inventory.product_id,
      quantity: 100
    }

    put "/api/v1/trucks/#{fake_truck_id}/inventory", params: params
    expect(response).to have_http_status(:not_found)
  end
end

describe "GET /api/v1/trucks/:id/inventory", type: :request do
  let(:truck) { create(:truck, :with_products) }

  before { get "/api/v1/trucks/#{truck.id}/inventory" }
  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end

  it 'response contains information about truck inventory' do
    data = JSON.parse(response.body)['data']
    expect(data).to have_key('inventory')
  end
end