Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  namespace :webhooks, path: 'api/v1' do
    resources :employees, only: %i[index create show update destroy]
  end
  
  resources :employees do
    get :fetch_third_party_employees, on: :collection
  end

  # Defines the root path route ("/")
  root 'employees#index'
end
