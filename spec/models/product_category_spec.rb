require "rails_helper"

RSpec.describe ProductCategory, type: :model do
  let(:category) { build :category, name: "Ice Cream"}
  
  describe ".associations" do
    it "has many products" do
      expect(ProductCategory.reflect_on_association(:products).macro).to eq(:has_many)
    end
  end
  
  describe ".properties" do
    it "has a name" do
      expect(category.name).to eq("Ice Cream")
    end
  end
  
end
