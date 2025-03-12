class OrdersProduct < ApplicationRecord
    # Associações
    belongs_to :order
    belongs_to :product

    # Validações
    validates :quantity, numericality: { greater_than: 0 }
end