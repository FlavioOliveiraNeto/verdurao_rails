class Order < ApplicationRecord
  # Associações
  belongs_to :user
  belongs_to :address, optional: true
  has_many :orders_products, dependent: :destroy
  has_many :products, through: :orders_products

  # Definição do enum de situações
  enum :situation, {
    completed: 0,          # Concluído
    awaiting_payment: 1,   # Aguardando pagamento
    active: 2,             # Ativo
    canceled: 3            # Cancelado
  }, prefix: true

  # Validações
  validates :total_price, :quantity, presence: true
  validates :total_price, numericality: { greater_than: 0 }
  validates :quantity, numericality: { greater_than: 0 }

  # Callback para calcular o total
  before_validation :calculate_total

  private

  def calculate_total
    self.total_price = orders_products.sum { |op| op.product.price * op.quantity }
    self.quantity = orders_products.sum(:quantity)
  end
end
