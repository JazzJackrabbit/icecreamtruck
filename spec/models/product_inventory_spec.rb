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
  end

  describe ".associations" do    
    it "belongs to product" do
      expect(ProductInventory.reflect_on_association(:product).macro).to eq(:belongs_to)
    end

    it "belongs to truck" do
      expect(ProductInventory.reflect_on_association(:truck).macro).to eq(:belongs_to)
    end
  end
  
  describe ".properties" do
    it "has quantity" do
      inventory = build :inventory, quantity: 5
      expect(inventory.quantity).to eq(5)
    end
  end
  
end
