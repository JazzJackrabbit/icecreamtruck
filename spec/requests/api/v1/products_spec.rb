require 'rails_helper'
require 'auth_helper'

describe "GET /api/v1/products/:id", type: :request do
  before { 
    category = create :category
    @product = create :product
   }

  context "when authenticated" do
    before { 
      @auth_headers = create_auth_headers
      get "/api/v1/products/#{@product.id}", headers: @auth_headers 
    }

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'response contains information about the product' do
      expect(JSON.parse(response.body)['data']).to have_key('product')
    end

    it 'returns a 404 response when product is not found by id', :skip_before_hook do
      fake_id = 123
      @auth_headers = create_auth_headers
      get "/api/v1/products/#{fake_id}", headers: @auth_headers
      expect(response).to have_http_status(:not_found)
    end
  end

  context "when not authenticated" do
    it 'returns status code 401' do
      get "/api/v1/products/#{@product.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

describe "GET /api/v1/products", type: :request do
  before { 
    @truck = create :truck, :with_products
    @products = @truck.products
    @category = @products.first.category
  }

  context "when authenticated" do
    before { 
      @auth_headers = create_auth_headers
      get "/api/v1/products", headers: @auth_headers 
    } 

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'response contains a list of products' do
      expect(JSON.parse(response.body)['data']).to have_key('products')
    end

    it 'the list of products can be filtered by price', :skip_before_hook do
      @auth_headers = create_auth_headers
      max_price = 10
      product = create :product, price: max_price+1


      get "/api/v1/products", params: { by_price: { max: max_price } }, headers: @auth_headers 
      data = JSON.parse(response.body)['data']
      expect(data).to have_key('products')
      expect(data['products'].size).not_to eq(0)
      expect(data['products'].map {|x| x['id'] }).not_to include(product.id)
    end

    it 'the list of products can be filtered by label', :skip_before_hook do
      @auth_headers = create_auth_headers
      label = 'newlabel'
      product = create :product, labels: [label] 

      get "/api/v1/products", params: { by_label: label }, headers: @auth_headers 
      data = JSON.parse(response.body)['data']
      expect(data).to have_key('products')
      expect(data['products'].size).to eq(1)
      expect(data['products'][0]['id']).to eq(product.id)
    end

    it 'the list of products can be filtered by name', :skip_before_hook do
      @auth_headers = create_auth_headers
      name = 'newname'
      product = create :product, name: name

      get "/api/v1/products", params: { by_name: name }, headers: @auth_headers 
      data = JSON.parse(response.body)['data']
      expect(data).to have_key('products')
      expect(data['products'].size).to eq(1)
      expect(data['products'][0]['id']).to eq(product.id)
    end

    it 'the list of products can be filtered by category', :skip_before_hook do
      @auth_headers = create_auth_headers
      new_category = create :category
      new_product = create :product, category: new_category

      get "/api/v1/products", params: { by_category: new_category.id }, headers: @auth_headers 
      data = JSON.parse(response.body)['data']
      expect(data).to have_key('products')
      expect(data['products'].size).to eq(1)
      expect(data['products'][0]['id']).to eq(new_product.id)
    end

    it "response contains pagination data", :skip_before_filter do
      @auth_headers = create_auth_headers
      get "/api/v1/products", params: { per_page: 1 }, headers: @auth_headers 

      data = JSON.parse(response.body)['data']
      expect(data).to have_key('meta')
      expect(data['meta']['page']).to eq(1)
      expect(data['meta']['total_pages']).to eq(Product.count)
    end
  end

  context "when not authenticated" do
    it "returns a 401 response" do
      get "/api/v1/products"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

describe "POST /api/v1/products", type: :request do
  before {
    @category = create :category
    @auth_headers = create_auth_headers
  }
  
  context "when authenticated" do
    it "creates a new product" do
      params = {
        name: 'New Product',
        price: 5.55,
        labels: ['newlabel'],
        category_id: @category.id
      }
      product_count = Product.count
      post "/api/v1/products", params: params, headers: @auth_headers 
      expect(response).to have_http_status(:created)
      expect(Product.count).to eq(product_count+1)
    end

    it "does not create a product without a category" do
      params = {
        name: 'New Product',
        price: 5.55,
        labels: ['newlabel'],
      }
      post "/api/v1/products", params: params, headers: @auth_headers 
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "does not create a product with invalid price" do
      params = {
        name: 'New Product',
        price: -1,
        labels: ['newlabel'],
        category_id: @category.id
      }
      post "/api/v1/products", params: params, headers: @auth_headers 
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  
  context "when not authenticated" do
    it "returns a 401 response" do
      params = {
        name: 'New Product',
        price: 5.55,
        labels: ['newlabel']
      }
      post "/api/v1/products", params: params
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

describe "PUT /api/v1/products/:id", type: :request do
  before {
    @category = create :category
    @product = create :product
    @auth_headers = create_auth_headers
  }

  context "when authenticated" do
    it "successfully updates product" do 
      params = {
        name: 'New Name',
        price: 12.34,
        labels: ['label'],
        category_id: @category.id
      }
      
      put "/api/v1/products/#{@product.id}", params: params, headers: @auth_headers
      expect(response).to have_http_status(:ok)

      product = Product.find(@product.id)
      expect(product.name).to eq('New Name')
      expect(product.price).to eq(12.34)
      expect(product.labels).to eq(['label'])
      expect(product.category).to eq(@category)
    end
  end

  context "when not authenticated" do
    it "returns a 401 error" do
      params = {
        name: 'New Product',
        price: 5.55,
        labels: ['newlabel'],
        category_id: @category.id
      }
      put "/api/v1/products/#{@product.id}", params: params
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

describe "DELETE /api/v1/products/:id", type: :request do
  before {
    @product = create :product
    @auth_headers = create_auth_headers
  }

  context "when authenticated" do
    it "successfully archives category" do      
      delete "/api/v1/products/#{@product.id}", headers: @auth_headers
      expect(response).to have_http_status(:ok)

      product = Product.find(@product.id)
      expect(product.archived?).to eq(true)
    end
  end

  context "when not authenticated" do
    it "returns a 401 error" do
      delete "/api/v1/products/#{@product.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end