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

    it "tests that order status value is within allowed range" do
      truck = create :truck, :with_products
      order = build :order, :with_truck_products, truck: truck

      statuses = ['new', 'complete']
      statuses.each do |value| 
        order.status = value
        expect(order).to be_valid
      end

      order.status = 'undefined'
      expect(order).not_to be_valid
    end

    it "cannot be updated after being completed" do
      truck = create :truck, :with_products
      order = create :order, :with_truck_products, truck: truck
      
      expect(order.update(total_amount: 123)).to eq(false)
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

    it "changes its status to complete" do  
      order = create :order, :with_truck_products, truck: truck, status: Order::STATUS[:new]

      expect(order.status).to eq(Order::STATUS[:complete])
    end

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

  it "does not allow modifications after it has been marked as complete" do
    truck = create :truck, :with_products  
    order = create :order, :with_truck_products, truck: truck

    expect(order.update(total_amount: 0)).to eq(false)
    # expect(order.status).to eq(Order::STATUS[:complete])
  end
end
