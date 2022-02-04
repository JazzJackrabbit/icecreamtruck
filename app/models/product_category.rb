class ProductCategory < ApplicationRecord
  has_many :products, foreign_key: :product_category_id

  validates_uniqueness_of :name

  scope :by_name, ->(name){where(name: name)}
end
