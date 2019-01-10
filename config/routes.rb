Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#home'

  devise_for :users,
    controllers: { registrations: 'registrations' }

  resources :users, only: %i(show)

  resources :posts, only: %i(index new create) do
    resources :photos, only: %i(create)
  end
end
