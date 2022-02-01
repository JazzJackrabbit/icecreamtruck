class Product < ApplicationRecord
  has_many :inventories, class_name: 'ProductInventory', foreign_key: :product_id, dependent: :destroy
  has_many :trucks, through: :inventories
  
  belongs_to :category, class_name: 'ProductCategory', foreign_key: :product_category_id

  validates :price, numericality: { greater_than_or_equal_to: 0 }  
end
