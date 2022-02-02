require "rails_helper"

RSpec.describe OrderItem, type: :model do
  describe ".validations" do
    it "cannot be created without a product" do
      order_item = build :order_item, product: nil

      expect(order_item).not_to be_valid
    end

    it "tests that quantity is above zero" do
      product = create :product
      order = build :order

      order_item = build :order_item, order: order, product: product, quantity: -1
      expect(order_item).not_to be_valid

      order_item = build :order_item, order: order, product: product, quantity: 0
      expect(order_item).not_to be_valid

      order_item = build :order_item, order: order, product: product, quantity: 1
      expect(order_item).to be_valid
    end
  end

  describe ".associations" do
    it "belongs to an order" do
      expect(OrderItem.reflect_on_association(:order).macro).to eq(:belongs_to)
    end

    it "belongs to a product" do
      expect(OrderItem.reflect_on_association(:product).macro).to eq(:belongs_to)
    end

    it "has one truck" do
      expect(OrderItem.reflect_on_association(:truck).macro).to eq(:has_one)
    end
  end

  describe "when created" do
    it "remembers product price and name at the time of the purchase" do
      truck = create :truck, :with_products
      order = create :order, :with_truck_products, truck: truck
      
      product = Product.find(order.items.first.product_id)
      expect(order.items.first.frozen_product_price).to eq(product.price)
      expect(order.items.first.frozen_product_name).to eq(product.name)
    end
  end
end
