Rails.application.routes.draw do
  root 'statics#index'
  get 'home', to: 'statics#index'
  devise_for :users
  resources :users, only: [:index, :show] do
    member do
      get :following, :followers
    end
  end
  resources :exams
  resources :relationships, only: [:create, :destroy]
end
