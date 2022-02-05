class AddArchivedToTrucks < ActiveRecord::Migration[7.0]
  def change
    add_column :trucks, :archived, :boolean, default: false
  end
end
