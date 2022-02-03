json.cache! ['api', 'v1', order], expires_in: 1.hour do
  json.data do 
    json.order do
      json.partial! partial: 'api/v1/orders/order', locals: {order: order, with_products: true}
    end
  end
end