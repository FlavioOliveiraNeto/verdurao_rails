Rails.application.routes.draw do
  namespace :api do
    resources :orders, only: [:index, :show, :create, :update, :destroy]
    resources :products, only: [:index, :show, :create, :update, :destroy]
    resources :users, only: [:index, :show, :create, :update, :destroy]
    resources :addresses, only: [:create, :index]

    namespace :users do
      resources :addresses, only: [:update, :destroy]
    end
  end

  # Rotas de autenticação
  post 'auth/login', to: 'authentication#login'
  post 'auth/register', to: 'authentication#register'

  # Rotas para "Esqueci minha senha"
  post 'password_reset', to: 'password_reset#create' # Solicitar redefinição de senha
  get 'password_reset/validate_token', to: 'password_reset#show' # Validar token
  put 'password_reset', to: 'password_reset#update' # Atualizar senha
end
