Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :profiles
  resources :contests
  resources :my_projects
  resource :inbox
  resource :company_dashboard
  resource :contest_ideas
  resource :logout
end
