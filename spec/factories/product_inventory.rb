FactoryBot.define do
  factory :product_inventory, aliases: [:inventory] do
    truck
    product 
    quantity { 0 }
  end
end