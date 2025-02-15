Rails.application.routes.draw do
  namespace :api do
    resources :products, only: [:index, :show, :create, :update, :destroy]
    resources :users, only: [:index, :show, :create, :update, :destroy]
  end

  post 'auth/login', to: 'authentication#login'
  post 'auth/register', to: 'authentication#register'
end
