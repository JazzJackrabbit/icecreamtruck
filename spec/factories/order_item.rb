FactoryBot.define do
  factory :order_item, aliases: [:item] do
    order
    product
    quantity { 1 }
  end
end