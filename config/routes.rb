Rails.application.routes.draw do
  root "static_pages#home"

  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/help", to: "static_pages#help"
  get "/login", to: "sessions#new"
  get "/signup", to: "users#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: :edit
  resources :password_resets
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
end
