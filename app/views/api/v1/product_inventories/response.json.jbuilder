json.message message
json.data do 
  json.inventory do
    json.partial! partial: 'api/v1/product_inventories/product_inventory', locals: {product_inventory: product_inventory}
  end
end