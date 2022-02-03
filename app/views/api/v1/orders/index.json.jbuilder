json.cache! ['api', 'v1', orders], expires_in: 1.hour do
  json.data do 
    json.total_revenue truck.revenue
    json.orders do
      json.array!(orders) do |order|
        json.partial! partial: 'api/v1/orders/order', locals: {order: order}
      end
    end
    json.partial! partial: 'api/v1/partials/pagination', locals: {pagination: @pagination}
  end
end