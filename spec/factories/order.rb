FactoryBot.define do
  factory :order do
    truck
    total_amount { 9.99 }

    trait :with_truck_products do
      transient do
        item_quantity { rand(1..5) }
      end

      before(:create) do |order,evaluator|
        products = order.truck.products

        order.truck.products.each do |product|
          item = build :order_item, order: order, product: product, quantity: evaluator.item_quantity
          order.items << item
        end
      end
    end
  end
end