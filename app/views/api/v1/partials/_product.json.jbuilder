json.id product.id
json.name product.name
json.price product.price

unless product.labels.empty?
  json.labels product.labels.join(',')
end