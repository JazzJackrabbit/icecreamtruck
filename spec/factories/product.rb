FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    price { 1.99 }
    association :category
    labels { [] }
  end
end