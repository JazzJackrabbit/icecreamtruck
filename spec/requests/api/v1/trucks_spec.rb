require 'rails_helper'
require 'auth_helper'

describe "GET /api/v1/trucks/:id", type: :request do
  let(:truck) { create :truck, :with_orders }

  before { get "/api/v1/trucks/#{truck.id}" }

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end

  it 'response contains information about truck products' do
    expect(JSON.parse(response.body)['data']).to have_key('products')
  end

  it 'returns a 404 response when truck is not found by id', :skip_before_hook do
    fake_id = 123

    get "/api/v1/trucks/#{fake_id}"
    expect(response).to have_http_status(:not_found)
  end

  it 'returns a 404 response when invalid truck id is provided', :skip_before_hook do
    fake_id = 'abc'

    get "/api/v1/trucks/#{fake_id}"
    expect(response).to have_http_status(:not_found)
  end
end

describe "GET /api/v1/trucks", type: :request do
  let(:trucks) { create_list(:truck, :with_products, 2) }

  before { get "/api/v1/trucks" }

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end

  it 'response contains a list of trucks' do
    expect(JSON.parse(response.body)['data']).to have_key('trucks')
  end

  it "response contains pagination data", :skip_before_filter do
    get "/api/v1/trucks", params: { per_page: 1 }

    data = JSON.parse(response.body)['data']
    expect(data).to have_key('meta')
    expect(data['meta']['page']).to eq(1)
    expect(data['meta']['total_pages']).to eq(Truck.count)
  end
end

describe "POST /api/v1/trucks", type: :request do
  before {
    @auth_headers = create_auth_headers
  }
  
  context "when authenticated" do
    it "creates a new truck" do
      params = {
        name: 'New Truck Name',
      }
      truck_count = Truck.count
      post "/api/v1/trucks", params: params, headers: @auth_headers
      expect(response).to have_http_status(:created)
      expect(Truck.count).to eq(truck_count+1)
    end
  end
  
  context "when not authenticated" do
    it "returns a 401 response" do
      params = {
        name: 'New Truck',
      }
      post "/api/v1/trucks", params: params
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

describe "PUT /api/v1/trucks/:id", type: :request do
  before {
    @truck = create :truck
    @auth_headers = create_auth_headers
  }

  context "when authenticated" do
    it "successfully updates truck" do
      name =  'New Truck Name'
      params = {
        name: name,
      }
      
      put "/api/v1/trucks/#{@truck.id}", params: params, headers: @auth_headers
      expect(response).to have_http_status(:ok)

      truck = Truck.find(@truck.id)
      expect(truck.name).to eq(name)
    end
  end

  context "when not authenticated" do
    it "returns a 401 error" do
      params = {
        name: 'New Truck Name',
      }
      put "/api/v1/trucks/#{@truck.id}", params: params
      expect(response).to have_http_status(:unauthorized)
    end
  end
end