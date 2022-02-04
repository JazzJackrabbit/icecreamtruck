json.cache! ['api', 'v1', product], expires_in: 1.hour do
  json.data do 
    json.product do 
      json.partial! partial: 'api/v1/products/product', locals: {product: product, full: true}
    end
  end
end