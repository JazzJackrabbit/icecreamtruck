class AddFrozenDescriptorsToOrderItems < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :frozen_product_name, :string
    add_column :order_items, :frozen_product_price, :decimal, precision: 8, scale: 2
  end
end
