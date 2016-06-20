Rails.application.routes.draw do
  devise_for :users
  root 'books#index'
  resources :books, only: :show do
    resources :reviews, only: [:new, :create]
    collection do
      get 'search'
    end
  end
end
