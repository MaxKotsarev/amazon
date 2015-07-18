Rails.application.routes.draw do
  root 'pages#index'
  devise_for :customers, :controllers => { registrations: 'customers/registrations' }
  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  get '/shop', to: 'pages#shop', as: 'shop'
  get '/shop/categories/:id', to: 'categories#show', as: 'category'
  get '/books/:id', to: 'books#show', as: "book"
end
