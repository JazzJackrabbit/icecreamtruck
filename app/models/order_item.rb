class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_one :truck, through: :order
  
  validates_uniqueness_of :product_id, :scope => [:order_id]
  validates_presence_of :product_id
  validates :quantity, numericality: { greater_than: 0 }  

  before_create :freeze_product_info

  def price
    frozen_product_price || product.price
  end
  
  def total_amount
    price * quantity
  end

  protected
  def freeze_product_info
    self.frozen_product_name = product.name
    self.frozen_product_price = product.price
  end
end
