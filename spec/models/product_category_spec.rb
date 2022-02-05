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

  describe ".validations" do
    it "validaes uniqueness of name" do
      name = '123'
      category = create :category, name: name
      duplicate_category = build :category, name: name
      expect(duplicate_category).not_to be_valid
    end
  end

  it "can be archived" do
    category = create :category
    expect(category).to respond_to(:archive!)
    category.archive!
    expect(ProductCategory.find(category.id).archived).to eq(true)
  end

  it "when archived it also archives associated products" do
    category = create :category
    product = create :product, category: category
    expect(category).to respond_to(:archive!)
    category.archive!
    expect(Product.find(product.id).archived).to eq(true)
  end
  
end
