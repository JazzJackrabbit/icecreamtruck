require 'rails_helper'
require 'auth_helper'

RSpec.describe "Api::V1::Orders", type: :request do
  describe "POST api/v1/truck/:truck_id/orders" do
    let(:truck) { create :truck, :with_products }
    let(:inventory) { truck.inventories.first }
    it "returns a successful response when creating an order" do
      order_params = {
        items_attributes: [ 
          {
            product_id: inventory.product_id,
            quantity: inventory.quantity
          } 
        ]
      }

      post "/api/v1/trucks/#{truck.id}/orders", params: order_params
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['message']).to match(/ENJOY!/)
    end

    it "returns an error response when product inventory is insufficient" do
      order_params = {
        items_attributes: [ 
          {
            id: inventory.product_id,
            quantity: inventory.quantity+1
          } 
        ]
      }
      post "/api/v1/trucks/#{truck.id}/orders", params: order_params
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['message']).to match(/SO SORRY!/)
    end

    it "returns an error response when requested product is not found in the truck inventory" do
      product = create :product

      order_params = {
        items_attributes: [
          {
            product_id: product.id,
            quantity: 1
          } 
        ]
      }

      post "/api/v1/trucks/#{truck.id}/orders", params: order_params
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "GET /api/v1/trucks/:truck_id/orders" do
    before { 
      @truck = create :truck, :with_orders
      merchant = create :merchant
      login(merchant)
      @auth_params = get_auth_params_from_login_response_headers(response)
    }

    context "when authenticated" do
      before { get "/api/v1/trucks/#{@truck.id}/orders", headers: @auth_params }  

      it 'returns status code 200' do
        expect(response).to have_http_status(:success)
      end
    
      it 'response contains orders information' do
        expect(JSON.parse(response.body)['data']).to have_key('orders')
      end

      it 'response does not contain detailed order information (skips products)' do
        orders = JSON.parse(response.body)['data']['orders']

        orders.each do |order|
          expect(order).not_to have_key('products')
        end
      end

      it "response contains pagination data" do
        get "/api/v1/trucks/#{@truck.id}/orders", headers: @auth_params, params: { per_page: 1 }
        data = JSON.parse(response.body)['data']
        expect(data).to have_key('meta')
        expect(data['meta']['page']).to eq(1)
        expect(data['meta']['total_pages']).to eq(@truck.orders.count)
      end

      it 'response contains information about truck revenue' do
        data = JSON.parse(response.body)['data']
        expect(data).to have_key('total_revenue')
      end
    end

    context "when not authenticated" do
      it 'returns status code 401' do
        get "/api/v1/trucks/#{@truck.id}/orders"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET api/v1/trucks/:truck_id/orders/:id" do
    before(:all) { 
      truck = create :truck, :with_orders
      @order = truck.orders.first
      merchant = create :merchant
      login(merchant)
      @auth_params = get_auth_params_from_login_response_headers(response)
    }

    context "when authenticated" do
      before { get "/api/v1/orders/#{@order.id}", headers: @auth_params }

      it 'returns status code 200' do
        expect(response).to have_http_status(:success)
      end
    
      it 'response contains order information' do
        data = JSON.parse(response.body)['data']
        expect(data).to have_key('order')
        expect(data['order']['id']).to eq(@order.id)
      end

      it "response contains detailed order information (includes products)" do
        data = JSON.parse(response.body)['data']
        expect(data['order']).to have_key('products')
      end
    end

    context "when not authenticated" do
      it 'returns status code 401' do
        get "/api/v1/orders/#{@order.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
