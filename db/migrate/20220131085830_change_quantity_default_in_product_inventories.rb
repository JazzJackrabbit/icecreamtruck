class ChangeQuantityDefaultInProductInventories < ActiveRecord::Migration[7.0]
  def change
    change_column :product_inventories, :quantity, :integer, default: 0, min: 0
  end
end
