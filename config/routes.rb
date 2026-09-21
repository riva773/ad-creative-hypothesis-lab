Rails.application.routes.draw do
  devise_for :users, only: [ :sessions ]
  devise_scope :user do
    get "users/sign_up",
      to: "devise/registrations#new",
      as: :new_user_registration
    post "users",
      to: "devise/registrations#create",
      as: :user_registration
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
  root "welcome#index"
  resources :apps, except: [ :new ]
  resources :hypotheses, only: [ :create, :edit, :update, :destroy ]
  resources :ads, only: [ :create ]
  resources :ad_tests, only: [ :create, :update, :destroy ]
  resources :reviews, only: [ :create, :update ]
  get "ad_tests/results", to: "ad_tests#results"
  get "up" => "rails/health#show", as: :rails_health_check

end
