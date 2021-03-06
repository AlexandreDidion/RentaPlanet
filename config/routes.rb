Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:show]
  resources :planets do
    resources :bookings, only: [:create, :new]
  end
  resources :bookings, only: [:index, :destroy]
  patch "bookings/:id", to: "bookings#status!", as: :status_booking
end
