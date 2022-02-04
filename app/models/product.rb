class Product < ApplicationRecord
  has_many :inventories, class_name: 'ProductInventory', foreign_key: :product_id, dependent: :destroy
  has_many :trucks, through: :inventories
  
  belongs_to :category, class_name: 'ProductCategory', foreign_key: :product_category_id
  alias_attribute :category_id, :product_category_id

  validates :price, numericality: { greater_than_or_equal_to: 0 }

  scope :by_label, ->(label) { where(':label = ANY(labels)', label: label) }
  scope :by_name, ->(name){where(name: name)}
  scope :by_price, ->(min = 0, max = Float::INFINITY) { where(price: min..max) }
  scope :by_category, ->(category_id) { where(product_category_id: category_id.to_i) }

  scope :stocked_in_truck, ->(truck_id) { includes(:inventories).where(inventories: { truck_id: truck_id, quantity: 1.. })}

  default_scope { includes(:category) }

  before_save { labels.uniq! if labels_changed? }
end
