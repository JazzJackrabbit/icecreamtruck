class ProductCategory < ApplicationRecord
  has_many :products, foreign_key: :product_category_id
end
