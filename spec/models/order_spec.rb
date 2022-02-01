require "rails_helper"

RSpec.describe Order, type: :model do
  describe ".validations" do
    it "cannot be created without a truck" do
      order = build :order, truck: nil

      expect(order).not_to be_valid
    end

    it "cannot be created without any items" do
      truck = create :truck
      order = build :order, truck: truck

      expect(order).not_to be_valid
    end
  end

  describe ".associations" do    
    it "has many items" do
      expect(Order.reflect_on_association(:items).macro).to eq(:has_many)
    end
  end

  describe "when created" do
    let (:truck) { create :truck, :with_products }

    it "correctly counts total price from items" do  
      order = create :order, :with_truck_products, truck: truck

      total_amount = order.items.map { |item|
        item.price*item.quantity
      }.sum

      expect(order.total_amount).to eq(total_amount)
    end
  end
  
  
end
