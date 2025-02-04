Rails.application.routes.draw do
  namespace :api do
    resources :produtos, only: [:index, :show, :create, :update, :destroy]
  end  
end
