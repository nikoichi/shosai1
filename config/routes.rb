Rails.application.routes.draw do
  root 'books#index'
  resources :books, only: :show do
    collection do
      get 'search'
    end
  end
end
