json.message message
json.data do 
  json.product do 
    json.partial! partial: 'api/v1/product_categories/category', locals: {category: category}
  end
end
