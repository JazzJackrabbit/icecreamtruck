json.message message
json.data do 
  json.product do 
    json.partial! partial: 'api/v1/products/product', locals: {product: product, full: true}
  end
end
