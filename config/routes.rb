Rails.application.routes.draw do
  root 'statics#index'
  get 'home', to: 'statics#index'
  devise_for :users
  resources :users, only: [:index, :show] do
    member do
      get :following, :followers
    end
  end
  resources :exams do
    member do
      get :users_who_liked
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
end
