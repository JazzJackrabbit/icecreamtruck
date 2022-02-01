require "rails_helper"

RSpec.describe Truck, type: :model do
  describe ".validations" do

  end

  describe ".associations" do    
    it "has many inventories" do
      expect(Truck.reflect_on_association(:inventories).macro).to eq(:has_many)
    end

    it "has many products" do
      expect(Truck.reflect_on_association(:products).macro).to eq(:has_many)
    end

    it "has many orders" do
      expect(Truck.reflect_on_association(:orders).macro).to eq(:has_many)
    end
  end
  
  describe ".properties" do
    it "has a name" do
      name = "Ice Cream Truck #1"
      truck = build :truck, name: name
      expect(truck.name).to eq(name)
    end
  end

  describe "inventory manager" do
    let(:truck) { create :truck, :with_products }

    it "responds to inventory method call" do
      expect(truck).to respond_to(:inventory)
    end

    it "lists all inventory items" do
      product_inventory_list = ProductInventory.where(truck: truck)
      expect(truck.inventory.list).to eq(product_inventory_list)
    end

    it "finds individual product inventory info by id" do
      product = truck.products.first
      product_inventory = ProductInventory.where(truck: truck, product: product).first

      expect(truck.inventory.find(product.id)).to eq(product_inventory)
    end

    it "successfully creates new inventory records" do
      new_product = create :product
      quantity = 132
      truck.inventory.add(new_product.id, quantity)
      expect(truck.inventory.find(new_product.id).quantity).to eq(quantity)
    end

    it "correctly adds inventory quantity to existing products" do
      product = truck.products.first
      old_quantity = ProductInventory.where(truck: truck, product: product).first.quantity
      additional_items = 100
      truck.inventory.add(product.id, additional_items)
      expect(truck.inventory.find(product.id).quantity).to eq(old_quantity + additional_items)
    end

    it "correctly removes inventory quantity from existing products" do
      product = truck.products.first
      old_quantity = ProductInventory.where(truck: truck, product: product).first.quantity
      removed_items = 5
      truck.inventory.remove(product.id, removed_items)
      expect(truck.inventory.find(product.id).quantity).to eq(old_quantity - removed_items)
    end

    it "correctly sets inventory quantity" do
      product = truck.products.first
      old_quantity = ProductInventory.where(truck: truck, product: product).first.quantity
      new_quantity = old_quantity + 1
      truck.inventory.set(product.id, new_quantity)
      expect(truck.inventory.find(product.id).quantity).to eq(new_quantity)
    end

    it "correctly sets new product quantity after a successful order" do
      product = truck.products.first
      old_quantity = ProductInventory.where(truck: truck, product: product).first.quantity
      order_quantity = 5
      order_items = build_list :order_item, 1, product: product, quantity: order_quantity
      order = create :order, truck: truck, items: order_items
      expect(truck.inventory.find(product.id).quantity).to eq(old_quantity - order_quantity)
    end
  end
  
end
