Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { registrations: :registrations }

  scope 'api/v1', module: 'api/v1' do
    jsonapi_resources :users

    jsonapi_resources :projects do
      jsonapi_relationships
      resources :clones, only: [:create]
    end

    jsonapi_resources :memberships
    jsonapi_resources :rules
    jsonapi_resources :data_elements
    jsonapi_resources :phrases
    jsonapi_resources :statements
    jsonapi_resources :rule_conflicts
    jsonapi_resources :rule_relationships
  end

  root to: 'static_pages#index'
end
