Rails.application.routes.draw do
  get 'index/home'
  get 'index/search'
  get 'index/about'
  get 'index/contact'
  root 'index#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations' }
  # devise_for :users, :controllers => { registrations: 'registrations' }
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  resources :users
  resources :microposts
  resource :replies
  resources :identities

  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :relationships,       only: [:create, :destroy]
end
