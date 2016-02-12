Rails.application.routes.draw do
  devise_for :users

  scope 'api/v1', module: 'api/v1' do
    jsonapi_resource :current_user

    jsonapi_resources :users
    jsonapi_resources :projects
  end

  root to: 'static_pages#index'
end
