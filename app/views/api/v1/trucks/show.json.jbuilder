json.data do 
  json.id truck.id
  json.name truck.name
  json.revenue truck.revenue
  json.inventory do
    json.array!(truck.inventories) do |inventory|
      json.quantity inventory.quantity
      json.product do 
        json.id inventory.product.id
        json.name inventory.product.name
        json.price inventory.product.price
      end
    end
  end
end