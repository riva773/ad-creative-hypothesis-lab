Rails.application.routes.draw do
  devise_for :users
  root "apps#index"
  resources :apps
  resources :hypotheses, only: [ :create, :edit, :update, :destroy ]
  resources :ads, only: [ :create ]
  get "ad_tests/results", to: "ad_tests#results"
  get "up" => "rails/health#show", as: :rails_health_check
end
