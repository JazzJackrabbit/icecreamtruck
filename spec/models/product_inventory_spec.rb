require "rails_helper"

RSpec.describe ProductInventory, type: :model do
  describe ".validations" do
    it "tests that quantity is 0 or above" do
      valid_inventory = build :inventory, quantity: 0
      expect(valid_inventory).to be_valid

      valid_inventory = build :inventory, quantity: 1
      expect(valid_inventory).to be_valid

      invalid_inventory = build :inventory, quantity: -1
      expect(invalid_inventory).not_to be_valid

      invalid_inventory = build :inventory, quantity: nil
      expect(invalid_inventory).not_to be_valid
    end

    it "tests uniqueness of truck-product pair" do
      truck = create :truck
      product = create :product
      product_inventory = create :product_inventory, product: product, truck: truck, quantity: 1

      duplicate_product_inventory = build :product_inventory, product: product, truck: truck, quantity: 2

      expect(duplicate_product_inventory).not_to be_valid
    end
  end

  describe ".associations" do    
    it "belongs to product" do
      expect(ProductInventory.reflect_on_association(:product).macro).to eq(:belongs_to)
    end

    it "belongs to truck" do
      expect(ProductInventory.reflect_on_association(:truck).macro).to eq(:belongs_to)
    end

    it "has scopes for in stock and out of stock items" do
      truck = create :truck
      products = create_list :product, 2
      in_stock_inventory = create :product_inventory, truck: truck, product: products.first, quantity: 1
      out_of_stock_inventory = create :product_inventory, truck: truck, product: products.second, quantity: 0

      expect(ProductInventory.in_stock.first.id).to eq(in_stock_inventory.id)

      expect(ProductInventory.out_of_stock.first.id).to eq(out_of_stock_inventory.id)
    end

    it "has a scope for out of stock items" do
      expect(ProductInventory.reflect_on_association(:product).macro).to eq(:belongs_to)
    end
  end
  
  describe ".properties" do
    it "has quantity" do
      inventory = build :inventory, quantity: 5
      expect(inventory.quantity).to eq(5)
    end
  end

  describe ".class" do
    it "has a method to create or update inventory records" do
      truck = create :truck
      product = create :product
      quantity = 123

      expect(ProductInventory).to respond_to(:create_or_update)
      
      args = {
        truck_id: truck.id,
        product_id: product.id,
        quantity: quantity
      }
      inventory = ProductInventory.create_or_update(args)
      expect(inventory.quantity).to eq(quantity)

      new_quantity = 555
      args[:quantity] = new_quantity
      inventory = ProductInventory.create_or_update(args)
      expect(inventory.quantity).to eq(new_quantity)
    end
  end
  
end
