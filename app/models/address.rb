class Address < ApplicationRecord
    # Associações
    has_many :users_addresses, dependent: :destroy
    has_many :users, through: :users_addresses
    has_many :orders, dependent: :nullify

    # Validações
    validates :zip_code, :street, :number, :neighborhood, :city, :state, presence: true
    validates :zip_code, length: { is: 8 }

    # Callback para remover formatação antes da validação
    before_validation :normalize_zip_code

    private

    def normalize_zip_code
        self.zip_code = zip_code.gsub(/[^\d]/, '') if zip_code.present?
        self.zip_code = "#{zip_code[0..4]}-#{zip_code[5..7]}" rescue nil
    end
end