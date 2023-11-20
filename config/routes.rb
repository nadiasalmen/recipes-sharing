Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_for :users, path: 'api/users'
      resources :recipes, only: [:create, :index, :update]
    end
  end
end
