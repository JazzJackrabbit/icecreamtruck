class ProductInventory < ApplicationRecord
  include InventoryManager
  include AppErrors::InventoryErrors

  MIN_QUANTITY = 0
  # MAX_QUANTITY = 10000

  belongs_to :truck, touch: true
  belongs_to :product
  
  validates_uniqueness_of :truck_id, scope: [:product_id]
  validates_presence_of :quantity
  validates :quantity, 
            numericality: { 
              greater_than_or_equal_to: MIN_QUANTITY
            }

  scope :in_stock, -> (){ where(quantity: 1..) }
  scope :out_of_stock, -> () { where(quantity: 0) }
  # scope :by_quantity, -> (min = MIN_QUANTITY, max = MAX_QUANTITY) { quantity: min..max }

  def self.create_or_update(args)
    truck_id = args[:truck_id]
    product_id = args[:product_id]
    quantity = args[:quantity]

    inventory = InventoryManager.from_truck_id(truck_id)
    inventory.set(product_id, quantity)
  end
end
