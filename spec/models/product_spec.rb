require "rails_helper"

RSpec.describe Product, type: :model do
  let(:product) { build :product, name: "Chocolate Ice Cream", price: 1.99 }
  
  describe ".validations" do
    it "tests that the product is valid" do
      valid_product = build :product
      expect(valid_product).to be_valid
    end

    it "requires price to be positive" do
      invalid_product = build :product, price: -1
      expect(invalid_product).not_to be_valid
    end
  end

  describe ".associations" do
    it "belongs to a product category" do
      expect(Product.reflect_on_association(:category).macro).to eq(:belongs_to)
    end
  
    it "has many trucks" do
      expect(Product.reflect_on_association(:trucks).macro).to eq(:has_many)
    end

    it "has many inventories" do
      expect(Product.reflect_on_association(:inventories).macro).to eq(:has_many)
    end
  end
  
  describe ".properties" do
    it "has a name" do
      expect(product.name).to eq("Chocolate Ice Cream")
    end

    it "has a price" do
      expect(product.price).to eq(1.99)
    end
  end
  
end
