json.cache! ['api', 'v1', truck], expires_in: 1.hour do
  json.data do  
    json.partial! partial: 'api/v1/trucks/truck', locals: {truck: truck}
     
    json.products do
      json.array!(truck.inventory.products.order(id: :asc)) do |product|
        json.partial! partial: 'api/v1/products/product', locals: {product: product}
      end
    end
  end
end