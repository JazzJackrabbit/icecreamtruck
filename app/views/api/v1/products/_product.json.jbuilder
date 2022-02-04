
if (full ||= false)
  json.id product.id
  json.name product.name
  json.category_id product.product_category_id
  json.category product.category.name
  json.price product.price
  json.labels product.labels.join(',')
  json.created_at product.created_at.iso8601
  json.updated_at product.updated_at.iso8601
else
  json.id product.id
  json.name product.name
  json.category product.category.name
  json.price product.price
  json.labels product.labels.join(',')
end