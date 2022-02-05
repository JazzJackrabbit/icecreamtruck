class AddArchivedToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :archived, :boolean, default: false
  end
end
