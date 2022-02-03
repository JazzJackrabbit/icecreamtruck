json.cache! ['api', 'v1', product_inventories], expires_in: 1.hour do
  json.data do 
    json.inventory do
      json.array!(product_inventories) do |inventory|
        json.product do 
          json.partial! partial: 'api/v1/partials/product', locals: {product: inventory.product}
        end
        json.quantity inventory.quantity
        json.updated_at inventory.updated_at.iso8601
      end
    end
  end
end