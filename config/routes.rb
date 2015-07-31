Rails.application.routes.draw do
  root 'pages#home'
  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  devise_for :customers, controllers: { registrations: 'customers/registrations', 
                                        sessions: 'customers/sessions',
                                        passwords: 'customers/passwords', 
                                        omniauth_callbacks: "customers/omniauth_callbacks" }
  devise_scope :customer do
    get '/settings', to: 'customers#settings'
    put '/change_password', to: 'customers#change_password'
    put '/change_personal_info', to: 'customers#change_personal_info'
  end
  
  resources :orders, only: [:index, :show]
  resources :addresses, only: [:update, :create]  
  resources :books, only: [:show, :index] do 
    resources :ratings, only: [:new, :create]
  end
  resources :categories, only: [:show]
end
