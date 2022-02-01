class CreateProductInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :product_inventories do |t|
      t.references :truck, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
