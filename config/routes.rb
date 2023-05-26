Rails.application.routes.draw do
  mount Api::V1::Root => "/api/v1"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
