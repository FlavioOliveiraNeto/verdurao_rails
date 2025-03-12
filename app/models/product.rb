class Product < ApplicationRecord
    # Associações
    has_one_attached :image
    has_many :orders_products
    has_many :orders, through: :orders_products
    
    validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :description, presence: true
    validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :image, presence: true
end
