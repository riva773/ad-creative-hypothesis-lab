Rails.application.routes.draw do
  devise_for :users
  root "apps#index"
  resources :apps
  get "ad_tests/index", to: "ad_tests#index"
  get "ad_tests/results", to: "ad_tests#results"
  get "up" => "rails/health#show", as: :rails_health_check
end
