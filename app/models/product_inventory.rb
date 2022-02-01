class ProductInventory < ApplicationRecord
  MIN_QUANTITY = 0

  belongs_to :truck
  belongs_to :product
  
  validates_uniqueness_of :truck_id, :scope => [:product_id]
  validates_presence_of :quantity
  validates :quantity, 
            numericality: { 
              greater_than_or_equal_to: MIN_QUANTITY
            }
end
