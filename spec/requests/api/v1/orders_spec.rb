require 'rails_helper'

RSpec.describe "Api::V1::Orders", type: :request do
  describe "POST api/v1/orders" do
    let(:truck) { create :truck, :with_products }
    let(:inventory) { truck.inventories.first }
    it "returns a successful response when creating an order" do
      order_params = {
        truck_id: truck.id,
        items_attributes: [ 
          {
            product_id: inventory.product_id,
            quantity: inventory.quantity
          } 
        ]
      }

      post "/api/v1/orders", params: order_params
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['message']).to match(/ENJOY!/)
    end

    it "returns an error response when product inventory is insufficient" do
      order_params = {
        truck_id: truck.id,
        items_attributes: [ 
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
        items_attributes: [
          {
            product_id: product.id,
            quantity: 1
          } 
        ]
      }

      post "/api/v1/orders", params: order_params
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "GET api/v1/orders" do
    let(:truck) { create :truck, :with_orders }
    let(:truck_two) { create :truck, :with_orders }    
    before { get "/api/v1/orders" }


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

    it "returns a list of orders filtered by truck id", :skip_before_hook do
      get "/api/v1/orders", params: { by_truck: truck.id }
      orders = JSON.parse(response.body)['data']['orders']

      orders.each do |order|
        expect(order['truck_id']).to eq(truck.id)
      end
    end
  end

  describe "GET api/v1/orders/:id" do
    let(:truck) { create :truck, :with_orders }
    let(:order) { truck.orders.first }

    before { get "/api/v1/orders/#{order.id}" }

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  
    it 'response contains order information' do
      data = JSON.parse(response.body)['data']
      expect(data).to have_key('order')
      expect(data['order']['id']).to eq(order.id)
    end

    it "response contains detailed order information (includes products)" do
      data = JSON.parse(response.body)['data']
      expect(data['order']).to have_key('products')
    end
  end

end
