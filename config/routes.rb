Rails.application.routes.draw do
  devise_for :admins
  root 'pages#index'
  devise_for :customers, :controllers => { registrations: 'customers/registrations' }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  get '/shop', to: 'pages#shop', as: 'shop'
  
  get '/shop/categories/:id', to: 'categories#show', as: 'category'
  
  get '/books/:id', to: 'books#show', as: "book"
  
  get '/books/:id/reviews/new', to: 'ratings#new', as: "new_rating"
  post '/books/:id/reviews/create', to: 'ratings#create', as: "ratings"
end
