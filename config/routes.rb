Rails.application.routes.draw do
  root to: 'exams#index'
  resources :exams
end
