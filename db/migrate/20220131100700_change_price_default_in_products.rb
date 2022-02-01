class ChangePriceDefaultInProducts < ActiveRecord::Migration[7.0]
  def change
    change_column :products, :price, :decimal, precision: 8, scale: 2, default: 0, min: 0
  end
end
