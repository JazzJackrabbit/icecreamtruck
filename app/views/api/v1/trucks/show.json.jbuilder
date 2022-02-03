json.cache! ['api', 'v1', truck], expires_in: 1.hour do
  json.data do  
    json.id truck.id
    json.name truck.name

    json.products do
      json.array!(truck.inventory.products) do |product|
        json.partial! partial: 'api/v1/partials/product', locals: {product: product}
      end
    end
  end
end