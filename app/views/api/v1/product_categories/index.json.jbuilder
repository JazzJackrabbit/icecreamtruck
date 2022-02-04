json.cache! ['api', 'v1', categories], expires_in: 1.hour do
  json.data do 
    json.categories do 
      json.array! (categories) do |category|
        json.partial! partial: 'api/v1/product_categories/category', locals: {category: category}
      end
    end
  end
end