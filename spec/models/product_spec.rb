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

    it "shows products that are in stock" do
      truck = create :truck

      in_stock_product = create :product
      create :product_inventory, truck: truck, product: in_stock_product, quantity: 5

      out_of_stock_product = create :product
      create :product_inventory, truck: truck, product: out_of_stock_product, quantity: 0

      expect(Product.stocked_in_truck(truck.id).map(&:id)).to eq([in_stock_product.id])
    end
  end

  describe ".scopes" do
    it "can be searched by label" do
      product_one = create :product, labels: ['mint']
      product_two = create :product, labels: ['chocolate']

      expect(Product.by_label('mint')).to include(product_one)
      expect(Product.by_label('mint')).not_to include(product_two)
    end
  end
  
  describe ".properties" do
    it "has a name" do
      expect(product.name).to eq("Chocolate Ice Cream")
    end

    it "has a price" do
      expect(product.price).to eq(1.99)
    end

    context 'has many labels' do
      it "as an array" do
        product.labels << 'mint'
        expect(product.labels).to eq(['mint'])
      end

      it "which are are unique" do
        product.labels = ['mint','mint','strawberry']
        product.save
        expect(product.labels).to eq(['mint', 'strawberry'])
      end
    end
  end

  it "can be archived" do
    product = create :product
    expect(product).to respond_to(:archive!)
    product.archive!
    expect(Product.find(product.id).archived).to eq(true)
  end
  
end
