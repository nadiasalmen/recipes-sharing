Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users, path: '',
        path_names: {
          sign_in: 'login',
          sign_out: 'logout',
          registration: 'signup'
        },
        controllers: {
          sessions: 'api/v1/users/sessions',
          registrations: 'api/v1/users/registrations'
        }
      resources :recipes, only: [:create, :index, :update]
      resources :notifications, only: [:create]
    end
  end

  mount ActionCable.server => '/cable'
end
