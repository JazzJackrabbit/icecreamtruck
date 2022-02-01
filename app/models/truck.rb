class Truck < ApplicationRecord
  include TruckInventoryManagement

  has_many :inventories, class_name: 'ProductInventory', foreign_key: :truck_id
  has_many :products, through: :inventories
  has_many :orders

  def revenue
    orders.map(&:total_amount).sum
  end

  def inventory
    InventoryManager.new self
  end
end