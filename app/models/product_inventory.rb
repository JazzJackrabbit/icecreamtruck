class ProductInventory < ApplicationRecord
  include TruckInventoryManagement
  include AppErrors::InventoryErrors

  MIN_QUANTITY = 0

  belongs_to :truck
  belongs_to :product
  
  validates_uniqueness_of :truck_id, :scope => [:product_id]
  validates_presence_of :quantity
  validates :quantity, 
            numericality: { 
              greater_than_or_equal_to: MIN_QUANTITY
            }

  def self.create_or_update(args)
    truck_id = args[:truck_id]
    product_id = args[:product_id]
    quantity = args[:quantity]

    inventory = InventoryManager.from_truck_id(truck_id)
    inventory.set(product_id, quantity)
  end
end
