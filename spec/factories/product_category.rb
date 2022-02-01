FactoryBot.define do
  factory :product_category, class: 'ProductCategory', aliases: [:category] do
    sequence(:name) { |n| "Product Category #{n}" }
  end
end