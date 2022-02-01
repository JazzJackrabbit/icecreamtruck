FactoryBot.define do
  factory :truck do
    sequence(:name) { |n| "Truck ##{n}" }

    transient do 
      category_count { 3 }
      products_per_category { 3 }
      product_quantity { 100 }
      product_price { 5.00 }
    end

    trait :with_products do
      after(:create) do | truck, evaluator |
        evaluator.category_count.times do 
          category = create :category
          evaluator.products_per_category.times do 
            product = create :product, category: category, price: evaluator.product_price
            inventory = create :inventory, product: product, truck: truck, quantity: evaluator.product_quantity
          end
        end
      end
    end

    trait :with_orders do
      with_products

      transient do 
        order_count { 3 }
      end

      after(:create) do | truck, evaluator |
        create_list :order, evaluator.order_count, :with_truck_products, truck: truck
      end
    end
  end
end