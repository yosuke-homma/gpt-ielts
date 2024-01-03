Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      root 'statics#index'
      get 'home', to: 'statics#index'

      resources :users, only: [:index, :show] do
        member do
          get :following, :followers
        end
      end
    end
  end

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

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
