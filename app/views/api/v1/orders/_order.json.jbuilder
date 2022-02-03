json.id order.id
json.truck_id order.truck_id
json.total_amount order.total_amount
json.created_at order.created_at.iso8601

if (with_products ||= false)
  json.products do
    json.array!(order.items) do |item|
      json.product do 
        json.id item.product_id
        json.name item.frozen_product_name
        json.price item.frozen_product_price
      end
      json.quantity item.quantity
    end
  end
end