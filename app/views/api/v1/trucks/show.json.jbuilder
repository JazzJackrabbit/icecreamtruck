json.data do 
  json.id truck.id
  json.name truck.name
  json.revenue truck.revenue
  json.inventory do
    json.array!(truck.inventories) do |inventory|
      json.product do 
        json.id inventory.product.id
        json.name inventory.product.name
        json.price inventory.product.price
      end
      json.quantity inventory.quantity
    end
  end
end