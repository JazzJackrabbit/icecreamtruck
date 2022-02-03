class Order < ApplicationRecord
  STATUS = { new: 'new', complete: 'complete' }.freeze

  belongs_to :truck, touch: true
  has_many :items, class_name: 'OrderItem', dependent: :destroy
  accepts_nested_attributes_for :items, allow_destroy: true

  before_create :remove_products_from_inventory
  before_create :set_total_amount
  before_create :mark_as_complete
  

  validates_presence_of :items
  validates :items, length: { minimum: 1, message: "are required. Add at least one." }
  validates :status, inclusion: STATUS.values
  validate :disallow_updates_when_complete

  scope :by_truck, -> (truck_id) { where(truck_id: truck_id.to_i) }

  protected

  def remove_products_from_inventory
    items.each do |item|
      truck.inventory.remove(item.product_id, item.quantity)      
    end
  end

  def set_total_amount
    self.total_amount = items.map(&:total_amount).sum
  end

  def mark_as_complete
    self.status = STATUS[:complete]
  end

  def complete?
    status == STATUS[:complete]
  end

  def disallow_updates_when_complete
    if persisted? && changed? && complete?
      errors.add(:base, "Cannot update a completed order")
    end
  end
end
