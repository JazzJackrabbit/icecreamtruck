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

    it "has a scope to filter by truck id" do
      
        truck_one = create :truck, :with_products
        create_list :order, 2, :with_truck_products, truck: truck_one

        truck_two = create :truck, :with_products
        create_list :order, 2, :with_truck_products, truck: truck_two
      

      expect(Order.by_truck(truck_one.id).map(&:truck_id).uniq).to eq([truck_one.id])
    end
  end

  describe "when created" do
    let (:truck) { create :truck, :with_products }

    it "correctly counts total amount from its items" do  
      order = create :order, :with_truck_products, truck: truck

      total_amount = order.items.map { |item|
        item.price*item.quantity
      }.sum

      expect(order.total_amount).to eq(total_amount)
    end

    it "updates quantity of products in truck inventory" do  
      inventory_before = truck.inventories.map(&:quantity)

      order = create :order, :with_truck_products, truck: truck

      inventory_after = Truck.find(truck.id).inventories.map(&:quantity)

      expect(inventory_before).not_to eq(inventory_after)
    end

    it "correctly counts total amount from its items" do  
      order = create :order, :with_truck_products, truck: truck

      total_amount = order.items.map { |item|
        item.price*item.quantity
      }.sum

      expect(order.total_amount).to eq(total_amount)
    end
  end
end
