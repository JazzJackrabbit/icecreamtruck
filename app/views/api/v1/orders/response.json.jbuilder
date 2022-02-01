json.message message
json.data do
  json.order do
    json.partial! partial: 'api/v1/orders/order', locals: {order: order}
  end
end