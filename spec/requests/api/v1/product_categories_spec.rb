require 'rails_helper'
require 'auth_helper'

describe "GET /api/v1/categories/:id", type: :request do
  before { 
    @category = create :category
   }

  context "when authenticated" do
    before { 
      @auth_headers = create_auth_headers
      get "/api/v1/categories/#{@category.id}", headers: @auth_headers 
    }

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'response contains information about the category' do
      expect(JSON.parse(response.body)['data']).to have_key('category')
    end

    it 'returns a 404 response when category is not found by id', :skip_before_hook do
      fake_id = 123
      @auth_headers = create_auth_headers
      get "/api/v1/categories/#{fake_id}", headers: @auth_headers
      expect(response).to have_http_status(:not_found)
    end
  end

  context "when not authenticated" do
    it 'returns status code 401' do
      get "/api/v1/categories/#{@category.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

describe "GET /api/v1/categories", type: :request do
  before { 
    @categories = create_list :category, 3
  }

  context "when authenticated" do
    before { 
      @auth_headers = create_auth_headers
      get "/api/v1/categories", headers: @auth_headers 
    } 

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'response contains a list of categories' do
      expect(JSON.parse(response.body)['data']).to have_key('categories')
    end

    it 'response does not contain archived categories', :skip_before_hook do
      @auth_headers = create_auth_headers
      categories = create_list :category, 3
      category = categories.first
      category.archive!
      
      get "/api/v1/categories", headers: @auth_headers 
      expect(JSON.parse(response.body)['data']['categories'].map{|x| x['id']}).not_to include(category.id)
    end

    it 'the list of categories can be filtered by name', :skip_before_hook do
      @auth_headers = create_auth_headers
      name = 'newname'
      category = create :category, name: name

      get "/api/v1/categories", params: { by_name: name }, headers: @auth_headers 
      data = JSON.parse(response.body)['data']
      expect(data).to have_key('categories')
      expect(data['categories'].size).to eq(1)
      expect(data['categories'][0]['id']).to eq(category.id)
    end
  end

  context "when not authenticated" do
    it "returns a 401 response" do
      get "/api/v1/categories"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

describe "POST /api/v1/categories", type: :request do
  before {
    @auth_headers = create_auth_headers
  }
  
  context "when authenticated" do
    it "creates a new category" do
      params = {
        name: 'New Category Name',
      }
      category_count = ProductCategory.count
      post "/api/v1/categories", params: params, headers: @auth_headers
      expect(response).to have_http_status(:created)
      expect(ProductCategory.count).to eq(category_count+1)
    end
  end
  
  context "when not authenticated" do
    it "returns a 401 response" do
      params = {
        name: 'New Category',
      }
      post "/api/v1/categories", params: params
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

describe "PUT /api/v1/categories/:id", type: :request do
  before {
    @category = create :category
    @auth_headers = create_auth_headers
  }

  context "when authenticated" do
    it "successfully updates category" do
      name =  'New Name'
      params = {
        name: name,
      }
      
      put "/api/v1/categories/#{@category.id}", params: params, headers: @auth_headers
      expect(response).to have_http_status(:ok)

      category = ProductCategory.find(@category.id)
      expect(category.name).to eq(name)
    end
  end

  context "when not authenticated" do
    it "returns a 401 error" do
      params = {
        name: 'New Category',
      }
      put "/api/v1/categories/#{@category.id}", params: params
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

describe "DELETE /api/v1/categories/:id", type: :request do
  before {
    @category = create :category
    @auth_headers = create_auth_headers
  }

  context "when authenticated" do
    it "successfully archives category" do      
      delete "/api/v1/categories/#{@category.id}", headers: @auth_headers
      expect(response).to have_http_status(:ok)

      category = ProductCategory.find(@category.id)
      expect(category.archived?).to eq(true)
    end
  end

  context "when not authenticated" do
    it "returns a 401 error" do
      delete "/api/v1/categories/#{@category.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end