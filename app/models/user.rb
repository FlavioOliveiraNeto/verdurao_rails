class User < ApplicationRecord
  has_secure_password

  # Defina os papéis manualmente
  ROLES = {
    admin: 0,
    customer: 1
  }.freeze

  # Método para retornar o hash de papéis
  def self.roles
    ROLES
  end

  # Método para verificar o papel do usuário
  def role
    ROLES.key(read_attribute(:role))
  end

  # Método para definir o papel do usuário
  def role=(role_name)
    write_attribute(:role, ROLES[role_name.to_sym])
  end

  # Métodos para verificar papéis específicos
  def admin?
    role == :admin
  end

  def customer?
    role == :customer
  end

  def generate_password_reset_token!
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.reset_password_sent_at = Time.now.utc
    save!(validate: false)
  end

  def reset_password_token_valid?
    (reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def clear_password_reset!
    self.reset_password_token = nil
    self.reset_password_sent_at = nil
    save!(validate: false)
  end

  # Associações
  has_many :orders, dependent: :destroy
  has_many :users_addresses, dependent: :destroy
  has_many :addresses, through: :users_addresses

  # Validações
  validates :name, :email, :cpf, :telephone, presence: true
  validates :email, uniqueness: true
  validates :cpf, uniqueness: true, length: { is: 11 }
  validates :password, presence: true, length: { minimum: 6 }
  validate :cpf_must_be_valid

  # Callback para remover formatação antes da validação
  before_validation :normalize_telephone,

  private

  def default_address
    addresses.joins(:users_addresses).find_by(users_addresses: { default: 1 })
  end

  def normalize_telephone
    self.telephone = telephone.gsub(/[^\d]/, '') if telephone.present?
    self.telephone = "(#{telephone[0..1]}) #{telephone[2..6]}-#{telephone[7..10]}" rescue nil
  end

  def cpf_must_be_valid
    errors.add(:cpf, "inválido") unless CPF.valid?(cpf)
  end

  def password_required?
    new_record? || password.present?
  end
end