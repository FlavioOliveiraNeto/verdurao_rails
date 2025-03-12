class UsersAddress < ApplicationRecord
    # Associações
    belongs_to :user
    belongs_to :address

    # Validações
    validates :user_id, uniqueness: { scope: :address_id }
    validates :default, inclusion: { in: [0, 1] }

    # Callback para garantir apenas um endereço padrão
    before_save :ensure_single_default

    private

    def ensure_single_default
        if default == 1
        UsersAddress.where(user_id: user_id, default: 1).update_all(default: 0)
        end
    end
end