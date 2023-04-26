Rails.application.routes.draw do
  root 'statics#index'
  get 'home', to: 'statics#index'
  devise_for :users
  resources :exams
end
