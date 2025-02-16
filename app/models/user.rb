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

  # Validações
  validates :name, presence: true, length: { minimum: 3 }
  validates :cpf, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validate :cpf_must_be_valid

  private

  def cpf_must_be_valid
    errors.add(:cpf, "inválido") unless CPF.valid?(cpf)
  end

  def password_required?
    new_record? || password.present?
  end
end