Rails.application.routes.draw do
  devise_for :admins
  root 'pages#index'
  devise_for :customers, controllers: { registrations: 'customers/registrations', 
                                        sessions: 'customers/sessions', 
                                        omniauth_callbacks: "customers/omniauth_callbacks" }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  get '/shop', to: 'pages#shop'
  resources :orders, only: [:index, :show]
  resources :addresses, only: [:update, :create]

  put '/check_params', to: "addresses#check_params"



  get '/settings', to: 'settings#index'
  put '/change_password', to: 'settings#change_password'
  put '/change_personal_info', to: 'settings#change_personal_info'
  
  get '/shop/categories/:id', to: 'categories#show', as: 'category'
  
  get '/books/:id', to: 'books#show', as: "book"
  
  get '/books/:id/reviews/new', to: 'ratings#new', as: "new_rating"
  post '/books/:id/reviews/create', to: 'ratings#create', as: "ratings"
end
