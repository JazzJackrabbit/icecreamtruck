class AddLabelIndexToProducts < ActiveRecord::Migration[7.0]
  def change
    add_index  :products, :labels, using: 'gin'
  end
end
