require 'rails_helper'

RSpec.describe "Api::V1::Orders", type: :request do
  describe "POST api/v1/orders (create order)" do
    let(:truck) { create :truck, :with_products }

    it "returns a successful response when creating an order" do
      inventory =  truck.inventories.first
      order_params = {
        truck_id: truck.id,
        products: [ 
          {
            id: inventory.product_id,
            quantity: inventory.quantity
          } 
        ]
      }

      post "/api/v1/orders", params: order_params
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['message']).to match(/ENJOY!/)
    end

    it "returns an error response when product inventory is insufficient" do
      inventory =  truck.inventories.first
      order_params = {
        truck_id: truck.id,
        products: [ 
          {
            id: inventory.product_id,
            quantity: inventory.quantity+1
          } 
        ]
      }
      post "/api/v1/orders", params: order_params
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['message']).to match(/SO SORRY!/)
    end

    it "returns an error response when requested product is not found in the truck inventory" do
      product = create :product

      order_params = {
        truck_id: truck.id,
        products: [
          {
            id: product.id,
            quantity: 1
          } 
        ]
      }

      post "/api/v1/orders", params: order_params
      expect(response).to have_http_status(:bad_request)
    end
  end

end
