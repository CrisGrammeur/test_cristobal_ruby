Rails.application.routes.draw do
  resources :users
  
  post 'login', to: 'sessions#create'
  get "up" => "rails/health#show", as: :rails_health_check
end
