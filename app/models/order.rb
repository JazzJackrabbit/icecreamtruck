class Order < ApplicationRecord
  belongs_to :truck
  has_many :items, class_name: 'OrderItem', dependent: :destroy
  accepts_nested_attributes_for :items, allow_destroy: true

  before_create :remove_products_from_inventory
  before_create :set_total_amount

  validates_presence_of :items
  validates :items, length: { minimum: 1, message: "are required. Add at least one." }

  scope :by_truck, -> (truck_id) { where(truck_id: truck_id) }

  def add_items(item_array)
    item_array.each do |item_hash|
      add_item item_hash[:id], item_hash[:quantity]
    end
  end

  protected

  def add_item(product_id, quantity)
    items << items.new(product_id: product_id, quantity: quantity)
  end

  def remove_products_from_inventory
    items.each do |item|
      truck.inventory.remove(item.product_id, item.quantity)      
    end
  end

  def set_total_amount
    self.total_amount = items.map(&:total_amount).sum
  end
end
