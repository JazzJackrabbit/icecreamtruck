class AddArchivedToProductCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :product_categories, :archived, :boolean, default: false
  end
end
