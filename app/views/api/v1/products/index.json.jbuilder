json.cache! ['api', 'v1', products], expires_in: 1.hour do
  json.data do 
    json.products do 
      json.array! (products) do |product|
        json.partial! partial: 'api/v1/products/product', locals: {product: product, full: true}
      end
    end
    json.partial! partial: 'api/v1/partials/pagination', locals: {pagination: @pagination}
  end
end