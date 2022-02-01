require 'rails_helper'

describe "GET /api/v1/trucks/:id", type: :request do
  let(:truck) { create :truck, :with_orders }

  before { get "/api/v1/trucks/#{truck.id}" }

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end

  it 'response contains information about truck inventory' do
    expect(JSON.parse(response.body)['data']).to have_key('inventory')
  end

  it 'response contains information about truck revenue' do
    expect(JSON.parse(response.body)['data']).to have_key('revenue')
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
end