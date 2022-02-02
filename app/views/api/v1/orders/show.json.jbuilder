json.data do 
  json.order do
    json.partial! partial: 'api/v1/orders/order', locals: {order: order, with_products: true}
  end
end