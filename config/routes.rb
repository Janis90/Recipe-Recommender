Rails.application.routes.draw do


  root 'page#welcome'

  resources :friendships, only: [:index, :create, :destroy] do
    member do
      post 'accept_friend/:id' => 'friendships#accept_friend', as: 'accept_friend'
      post 'decline_friend/:id' => 'friendships#decline_friend', as:'decline_friend'
    end
  end

 devise_for :users, controllers: { registrations: "registrations" }

 resources :users, only: [:index, :show, :edit, :update] do
   member do
     post 'change_admin_status/:id' => 'users#change_admin_status', as: 'change_admin_status'
   end
 end

 resources :allergies
 resources :ingredients
 resources :events
 resources :recipes

  get 'my_recipes' => 'recipes#my_recipes', as: 'my_recipes'
  post 'recipes/add_recipe/:id' => 'recipes#add_recipe', as: 'add_recipe'
  post 'search_for_recipes' => 'recipes#search_for_recipes', as: 'search_for_recipes'

 delete 'decline_event/:id' => 'events#decline_event', as: 'decline_event'
  get 'show_recommendations/:id' => 'events#show_recommendations', as: 'show_recommendations'
end
