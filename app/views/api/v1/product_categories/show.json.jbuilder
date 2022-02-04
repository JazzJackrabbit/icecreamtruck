json.cache! ['api', 'v1', category], expires_in: 1.hour do
  json.data do 
    json.category do 
      json.partial! partial: 'api/v1/product_categories/category', locals: {category: category}
    end
  end
end