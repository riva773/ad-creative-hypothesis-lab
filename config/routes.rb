Rails.application.routes.draw do
  root "ad_tests#index"
  get "up" => "rails/health#show", as: :rails_health_check

end
