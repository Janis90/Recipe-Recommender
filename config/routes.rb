Rails.application.routes.draw do

  root 'page#welcome'

  resources :friendships, only: [:index, :create, :destroy] do
    member do
      post 'accept_friend/:id' => 'friendships#accept_friend', as: 'accept_friend'
      post 'decline_friend/:id' => 'friendships#decline_friend', as:'decline_friend'
    end
  end

 devise_for :users, controllers: { registrations: "registrations" }

 resources :users, only: [:show, :edit, :update]
 resources :allergies
 resources :ingredients
 resources :events

 delete 'decline_event/:id' => 'events#decline_event', as: 'decline_event'
end
