Rails.application.routes.draw do
  devise_for :users, path: 'api/users'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
