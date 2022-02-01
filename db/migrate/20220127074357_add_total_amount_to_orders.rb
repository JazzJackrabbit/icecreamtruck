class AddTotalAmountToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :total_amount, :decimal, precision: 8, scale: 2
  end
end
