class OrderItem < ApplicationRecord
  belongs_to :order, touch: true
  belongs_to :product, touch: true
  has_one :truck, through: :order
  
  validates_uniqueness_of :product_id, :scope => [:order_id]
  validates_presence_of :product_id
  validates :quantity, numericality: { greater_than: 0 }
  validate :disallow_changes_when_persisted

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

  def disallow_changes_when_persisted
    if persisted? && changed?
      errors.add(:base, 'Cannot be modified after created')
    end
  end
end
