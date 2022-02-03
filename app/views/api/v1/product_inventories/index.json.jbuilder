json.cache! ['api', 'v1', product_inventories], expires_in: 1.hour do
  json.data do 
    json.inventory do
      json.array!(product_inventories) do |inventory|
        json.product_id inventory.product_id
        json.quantity inventory.quantity
      end
    end
  end
end