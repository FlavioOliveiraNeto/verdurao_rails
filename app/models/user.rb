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
end