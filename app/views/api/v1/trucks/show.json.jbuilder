json.data do 
  json.id truck.id
  json.name truck.name
  json.revenue truck.revenue
  json.products do
    json.array!(truck.inventory.products) do |product|
      json.id product.id
      json.name product.name
      json.price product.price
    end
  end
end