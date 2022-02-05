class ProductCategory < ApplicationRecord
  include Archivable

  has_many :products, foreign_key: :product_category_id

  validates_uniqueness_of :name

  scope :by_name, ->(name){where(name: name)}

  def archive!
    update(name: SecureRandom.alphanumeric(64)) #change name to allow future name validations
    products.each { |p| p.archive! }
    super
  end
end
